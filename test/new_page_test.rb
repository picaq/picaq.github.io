# frozen_string_literal: true

# Tests for bin/new-page.
#
#   ruby test/new_page_test.rb
#
# Run with plain ruby, not `bundle exec` — minitest ships with ruby but is not in
# the Gemfile, and the script itself is stdlib-only by design.
#
# Almost everything here uses --dry-run, so the real blog/ tree is never touched.
# The handful of tests that write for real confine themselves to SCRATCH and
# remove it in teardown.

require "minitest/autorun"
require "open3"
require "yaml"
require "date"
require "fileutils"

ROOT    = File.expand_path("..", __dir__)
SCRIPT  = File.join(ROOT, "bin", "new-page")
BLOG    = File.join(ROOT, "blog")
SCRATCH = "zz-scaffold-test"

module Runner
  def new_page(*args)
    out, err, status = Open3.capture3(SCRIPT, *args)
    [out, err, status.exitstatus]
  end

  # The rendered file a dry run prints after its "would write <path>" line.
  def body(*args)
    out, err, code = new_page("-n", *args)
    raise "expected success, got exit #{code}\n#{err}" unless code.zero?

    out.split("\n", 2).last.lstrip
  end

  def front_matter(*args)
    raw = body(*args).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1]
    YAML.safe_load(raw, permitted_classes: [Date, Time])
  end

  # An oracle for nav_order that doesn't share code with the script: read every
  # page, keep the ones with this parent, take the highest.
  def max_nav_order_under(parent)
    Dir.glob("#{BLOG}/**/*.md").filter_map do |file|
      match = File.read(file).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)
      next unless match

      # Symbol because blog/gists/css/has.md has `title: :has()`
      fm = YAML.safe_load(match[1], permitted_classes: [Date, Time, Symbol]) || {}
      next unless fm["parent"] == parent

      fm["nav_order"]
    end.max
  end
end

# Slugs come from the title, and the title can be anything.
class SlugTest < Minitest::Test
  include Runner

  def test_accents_are_transliterated_not_stripped
    assert_equal "blog/food/creme-brulee", front_matter("page", "food", "Crème Brûlée")["permalink"]
  end

  def test_ampersand_becomes_the_word_and
    assert_equal "blog/food/salt-and-pepper", front_matter("page", "food", "Salt & Pepper")["permalink"]
  end

  def test_punctuation_collapses_to_a_single_hyphen
    assert_equal "blog/food/has", front_matter("page", "food", ":has()")["permalink"]
  end

  def test_slug_can_be_overridden
    fm = front_matter("page", "food", "Cheese et Cetera", "--slug", "cheese-etc")
    assert_equal "blog/food/cheese-etc", fm["permalink"]
  end
end

# parent: is a string match against another page's title:, so it has to be read
# off disk rather than guessed from the directory name.
class ParentTest < Minitest::Test
  include Runner

  def test_parent_is_the_index_title_not_the_directory_name
    # directory is "javascript", the title is "JavaScript"
    assert_equal "JavaScript", front_matter("page", "gists/javascript", "Zz Test")["parent"]
  end

  def test_finds_an_index_that_lives_inside_the_folder
    assert_equal "Skincare", front_matter("page", "skincare", "Zz Test")["parent"]
  end

  def test_finds_an_index_that_lives_one_level_up
    # blog/food/recipes/ keeps its index at blog/food/recipes.md
    assert_equal "Recipes", front_matter("recipe", "food/recipes", "Zz Test")["parent"]
  end

  def test_a_top_level_section_gets_no_parent_line_at_all
    refute front_matter("folder", SCRATCH, "Zz Test").key?("parent")
  end

  def test_a_sub_section_inherits_its_containing_section
    assert_equal "Food", front_matter("folder", "food/#{SCRATCH}", "Zz Test")["parent"]
  end

  def test_parent_can_be_overridden
    assert_equal "Shell", front_matter("page", "gists", "Zz Test", "--parent", "Shell")["parent"]
  end
end

class NavOrderTest < Minitest::Test
  include Runner

  def test_is_one_past_the_highest_sibling
    expected = max_nav_order_under("Skincare") + 1
    assert_equal expected, front_matter("page", "skincare", "Zz Test")["nav_order"]
  end

  def test_groups_siblings_by_parent_not_by_directory
    # blog/gists/wsl.md sits in gists/ but belongs to Shell
    expected = max_nav_order_under("Shell") + 1
    assert_equal expected, front_matter("page", "gists", "Zz Test", "--parent", "Shell")["nav_order"]
  end

  def test_can_be_overridden
    assert_equal 42, front_matter("page", "skincare", "Zz Test", "--nav-order", "42")["nav_order"]
  end
end

# Titles are free text and end up in YAML, so they have to survive the round trip.
class YamlSafetyTest < Minitest::Test
  include Runner

  def test_a_colon_in_the_title_does_not_break_the_document
    assert_equal "Tips: Do This", front_matter("page", "food", "Tips: Do This")["title"]
  end

  def test_a_numeric_title_stays_a_string
    title = front_matter("page", "food", "42")["title"]
    assert_equal "42", title
    assert_instance_of String, title
  end

  def test_an_ampersand_title_round_trips
    assert_equal "Dungeons & Dragons", front_matter("page", "games", "Dungeons & Dragons")["title"]
  end
end

class RecipeTemplateTest < Minitest::Test
  include Runner

  def recipe_body
    body("recipe", "food/recipes", "Zz Test Recipe")
  end

  def test_liquid_survives_substitution_untouched
    assert_includes recipe_body, "{% render_recipe %}"
  end

  def test_uses_the_recipe_layout
    assert_equal "recipe", front_matter("recipe", "food/recipes", "Zz Test")["layout"]
  end

  def test_date_uses_the_unpadded_hour_format_of_existing_recipes
    date = recipe_body[/^date: (.+)$/, 1]
    assert_match(/\A\d{4}-\d{2}-\d{2} \d{1,2}:\d{2}:\d{2} [-+]\d{4}\z/, date)
  end

  # cheesy-peas.md, spicy-cold-tofu.md and natto-nacho-cheese.md each declare
  # tags: twice, and YAML silently drops the first. Don't regress into that.
  def test_declares_each_key_exactly_once
    keys = recipe_body[/\A---\s*\n(.*?\n?)^---\s*\n/m, 1].scan(/^([a-z_]+):/).flatten
    assert_equal keys.uniq, keys, "duplicate front matter keys: #{keys.tally.select { |_, n| n > 1 }.keys}"
  end

  # The template is only useful if it offers every field the plugin reads.
  def test_covers_every_field_the_plugin_consumes
    plugin = File.read(File.join(ROOT, "_plugins", "recipe_tag.rb"))
    # intro, intro_blurb and ingredients_intro are fallback spellings of excerpt
    # and ingredients_blurb, not fields in their own right.
    aliases = %w[intro intro_blurb ingredients_intro]
    fields = plugin.scan(/page\['([a-z_]+)'\]/).flatten.uniq - aliases
    template = File.read(File.join(ROOT, "_templates", "recipe.md"))
    missing = fields.reject { |f| template.match?(/^#?\s*#{Regexp.escape(f)}:/) }
    assert_empty missing, "recipe_tag.rb reads these but the template omits them: #{missing}"
  end

  def test_nutrition_subkeys_are_present_so_the_gated_block_renders
    # recipe_tag.rb:83 renders cuisine/diet/category/keywords only if nutrition.any?
    assert front_matter("recipe", "food/recipes", "Zz Test")["nutrition"].any?
  end
end

class PageTemplateTest < Minitest::Test
  include Runner

  def test_omits_layout_so_the_site_default_applies
    refute front_matter("page", "skincare", "Zz Test").key?("layout")
  end

  def test_opens_with_an_h1_matching_the_title
    assert_includes body("page", "skincare", "Zz Test Page"), "# Zz Test Page"
  end
end

class FailureTest < Minitest::Test
  include Runner

  def test_refuses_to_overwrite_an_existing_page
    _out, err, code = new_page("-n", "page", "skincare", "Moisturizers")
    refute_equal 0, code
    assert_match(/refusing to overwrite/, err)
  end

  def test_rejects_a_folder_that_does_not_exist
    _out, err, code = new_page("-n", "page", "no-such-folder", "Zz Test")
    refute_equal 0, code
    assert_match(/does not exist/, err)
  end

  def test_rejects_a_sub_section_whose_parent_section_is_missing
    _out, err, code = new_page("-n", "folder", "no-such-folder/deeper", "Zz Test")
    refute_equal 0, code
    assert_match(/no section index found/, err)
  end

  def test_refuses_to_re_create_an_existing_section
    _out, err, code = new_page("-n", "folder", "skincare", "Skincare")
    refute_equal 0, code
    assert_match(/already has a section index/, err)
  end

  def test_fails_cleanly_when_it_cannot_prompt
    _out, err, code = new_page("page")
    refute_equal 0, code
    assert_match(/no terminal to prompt on/, err)
    refute_match(/backtrace|\.rb:\d+:in/, err)
  end
end

# The only tests that touch the filesystem.
class WriteTest < Minitest::Test
  include Runner

  def teardown
    FileUtils.rm_rf(File.join(BLOG, SCRATCH))
    FileUtils.rm_f(File.join(BLOG, "#{SCRATCH}.md"))
  end

  def test_creates_a_section_then_a_page_that_finds_it_as_parent
    _out, err, code = new_page("folder", SCRATCH, "Zz Scaffold Test")
    assert_equal 0, code, err
    assert File.file?("#{BLOG}/#{SCRATCH}/#{SCRATCH}.md"), "section index not written"

    _out, err, code = new_page("page", SCRATCH, "First Page")
    assert_equal 0, code, err

    page = "#{BLOG}/#{SCRATCH}/first-page.md"
    assert File.file?(page), "page not written"

    fm = YAML.safe_load(File.read(page).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1])
    assert_equal "Zz Scaffold Test", fm["parent"], "did not read the new section's title"
    assert_equal "blog/#{SCRATCH}/first-page", fm["permalink"]
  end

  def test_dry_run_writes_nothing
    new_page("-n", "folder", SCRATCH, "Zz Scaffold Test")
    refute File.exist?("#{BLOG}/#{SCRATCH}/#{SCRATCH}.md")
  end
end
