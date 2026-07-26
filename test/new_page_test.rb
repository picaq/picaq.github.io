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
  # Keep the editor out of it unless a test is specifically about opening.
  NO_OPEN = { "NEW_PAGE_OPEN" => "" }.freeze

  def new_page(*args)
    out, err, status = Open3.capture3(NO_OPEN, SCRIPT, *args)
    [out, err, status.exitstatus]
  end

  # Paths the script hands to the editor, with echo standing in for `code`.
  def opened(*args)
    out, _err, _status = Open3.capture3({ "NEW_PAGE_OPEN" => "echo OPENED" }, SCRIPT, *args)
    out.scan(/^OPENED (\S+)$/).flatten
  end

  # Everything a dry run says it would write, in order.
  def written(*args)
    out, err, code = new_page("-n", *args)
    raise "expected success, got exit #{code}\n#{err}" unless code.zero?

    out.scan(/^would write\s+(\S+)$/).flatten
  end

  # The rendered file a dry run prints after its "would write" lines.
  def body(*args)
    out, err, code = new_page("-n", *args)
    raise "expected success, got exit #{code}\n#{err}" unless code.zero?

    out[/^---\s*$.*/m]
  end

  def front_matter(*args)
    YAML.safe_load(body(*args).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1],
                   permitted_classes: [Date, Time, Symbol])
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

# The path is the permalink, and the type decides what its last segment means.
class PathTest < Minitest::Test
  include Runner

  def test_for_a_page_the_last_segment_is_the_page
    assert_equal "blog/skincare/sunscreen", front_matter("page", "skincare/sunscreen")["permalink"]
  end

  def test_for_a_folder_the_whole_path_is_the_section
    assert_equal ["blog/#{SCRATCH}/inner.md"], written("folder", "#{SCRATCH}/inner", "Inner")[-1..]
    assert_equal "blog/#{SCRATCH}/inner", front_matter("folder", "#{SCRATCH}/inner", "Inner")["permalink"]
  end

  def test_a_page_with_no_folder_lands_at_the_top_level
    fm = front_matter("page", "teaching-notes")
    assert_equal "blog/teaching-notes", fm["permalink"]
    refute fm.key?("parent")
  end

  def test_a_leading_blog_prefix_is_tolerated
    assert_equal "blog/skincare/sunscreen", front_matter("page", "blog/skincare/sunscreen")["permalink"]
  end

  def test_segments_are_normalized
    assert_equal "blog/food/creme-brulee", front_matter("page", "food/Crème Brûlée")["permalink"]
  end

  def test_an_empty_path_is_rejected
    _out, err, code = new_page("-n", "page", "/")
    refute_equal 0, code
    assert_match(/PATH is empty/, err)
  end
end

# The reported bug: making a page and its folder in one command.
class MissingSectionTest < Minitest::Test
  include Runner

  def test_creates_the_missing_section_then_the_page
    assert_equal ["blog/internet/internet.md", "blog/internet/domain.md"],
                 written("page", "internet/domain")
  end

  def test_the_page_is_parented_to_the_section_it_just_made
    assert_equal "Internet", front_matter("page", "internet/domain")["parent"]
  end

  def test_creates_a_whole_missing_chain
    assert_equal ["blog/a/a.md", "blog/a/b.md", "blog/a/b/c.md", "blog/a/b/c/d.md"],
                 written("page", "a/b/c/d")
  end

  def test_writes_the_section_once_not_twice
    paths = written("folder", "internet/domain", "Domain")
    assert_equal paths.uniq, paths, "a section was written more than once"
  end

  def test_existing_sections_are_left_alone
    assert_equal ["blog/skincare/sunscreen.md"], written("page", "skincare/sunscreen")
  end

  def test_warns_when_the_result_is_deeper_than_the_theme_renders
    _out, err, = new_page("-n", "page", "a/b/c/d")
    assert_match(/4 levels deep/, err)
  end

  def test_does_not_warn_at_three_levels
    _out, err, = new_page("-n", "page", "a/b/c")
    refute_match(/levels deep/, err)
  end
end

class TitleTest < Minitest::Test
  include Runner

  def test_defaults_to_the_title_cased_slug
    assert_equal "Domain", front_matter("page", "internet/domain")["title"]
  end

  def test_hyphens_become_spaces_in_the_default
    assert_equal "Miso Soup", front_matter("recipe", "food/recipes/miso-soup")["title"]
  end

  # blog/design/squint is taken, so use a free slug to show the same shape:
  # a short path with a longer title, which is how most pages here are set up.
  def test_an_explicit_title_wins_and_the_slug_stays_short
    fm = front_matter("page", "design/kern", "Kerning and Tracking")
    assert_equal "Kerning and Tracking", fm["title"]
    assert_equal "blog/design/kern", fm["permalink"]
  end
end

# parent: is a string match against another page's title:, so it has to be read
# off disk rather than guessed from the directory name.
class ParentTest < Minitest::Test
  include Runner

  def test_parent_is_the_index_title_not_the_directory_name
    # directory is "javascript", the title is "JavaScript"
    assert_equal "JavaScript", front_matter("page", "gists/javascript/zz-test")["parent"]
  end

  def test_finds_an_index_that_lives_inside_the_folder
    assert_equal "Skincare", front_matter("page", "skincare/zz-test")["parent"]
  end

  def test_finds_an_index_that_lives_one_level_up
    # blog/food/recipes/ keeps its index at blog/food/recipes.md
    assert_equal "Recipes", front_matter("recipe", "food/recipes/zz-test")["parent"]
  end

  def test_a_top_level_section_gets_no_parent_line_at_all
    refute front_matter("folder", SCRATCH, "Zz Test").key?("parent")
  end

  def test_a_sub_section_inherits_its_containing_section
    assert_equal "Food", front_matter("folder", "food/#{SCRATCH}", "Zz Test")["parent"]
  end

  def test_parent_can_be_overridden
    assert_equal "Shell", front_matter("page", "gists/zz-test", "--parent", "Shell")["parent"]
  end

  def test_an_override_does_not_leak_onto_sections_made_on_the_way
    # --parent belongs to the page, not to blog/internet invented alongside it
    fm = YAML.safe_load(
      body("page", "internet/domain", "--parent", "Shell")
        .match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1]
    )
    assert_equal "Shell", fm["parent"]
  end
end

class NavOrderTest < Minitest::Test
  include Runner

  def test_is_one_past_the_highest_sibling
    expected = max_nav_order_under("Skincare") + 1
    assert_equal expected, front_matter("page", "skincare/zz-test")["nav_order"]
  end

  def test_groups_siblings_by_parent_not_by_directory
    # blog/gists/wsl.md sits in gists/ but belongs to Shell
    expected = max_nav_order_under("Shell") + 1
    assert_equal expected, front_matter("page", "gists/zz-test", "--parent", "Shell")["nav_order"]
  end

  def test_a_page_in_a_brand_new_section_starts_at_one
    assert_equal 1, front_matter("page", "internet/domain")["nav_order"]
  end

  def test_can_be_overridden
    assert_equal 42, front_matter("page", "skincare/zz-test", "--nav-order", "42")["nav_order"]
  end
end

# Titles are free text and end up in YAML, so they have to survive the round trip.
class YamlSafetyTest < Minitest::Test
  include Runner

  def test_a_colon_in_the_title_does_not_break_the_document
    assert_equal "Tips: Do This", front_matter("page", "food/tips", "Tips: Do This")["title"]
  end

  def test_a_numeric_title_stays_a_string
    title = front_matter("page", "food/answer", "42")["title"]
    assert_equal "42", title
    assert_instance_of String, title
  end

  def test_an_ampersand_title_round_trips
    assert_equal "Dungeons & Dragons", front_matter("page", "games/dnd2", "Dungeons & Dragons")["title"]
  end

  # blog/gists/css/has.md is `title: :has()`, which psych reads as a Symbol.
  # If the script drops that page it also drops it from every lookup.
  def test_a_symbol_title_page_still_participates_in_lookups
    expected = max_nav_order_under("CSS") + 1
    assert_equal expected, front_matter("page", "gists/css/zz-test")["nav_order"]
  end
end

class RecipeTemplateTest < Minitest::Test
  include Runner

  def recipe_body
    body("recipe", "food/recipes/zz-test-recipe")
  end

  def test_liquid_survives_substitution_untouched
    assert_includes recipe_body, "{% render_recipe %}"
  end

  def test_uses_the_recipe_layout
    assert_equal "recipe", front_matter("recipe", "food/recipes/zz-test")["layout"]
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
    assert front_matter("recipe", "food/recipes/zz-test")["nutrition"].any?
  end
end

class PageTemplateTest < Minitest::Test
  include Runner

  def test_omits_layout_so_the_site_default_applies
    refute front_matter("page", "skincare/zz-test").key?("layout")
  end

  def test_opens_with_an_h1_matching_the_title
    assert_includes body("page", "skincare/zz-test", "Zz Test Page"), "# Zz Test Page"
  end
end

class FailureTest < Minitest::Test
  include Runner

  def test_rejects_an_unknown_type
    _out, _err, code = new_page("-n", "widget", "skincare/zz-test")
    refute_equal 0, code
  end

  def test_fails_cleanly_when_it_cannot_prompt
    _out, err, code = new_page("page")
    refute_equal 0, code
    assert_match(/no terminal to prompt on/, err)
    refute_match(/backtrace|\.rb:\d+:in/, err)
  end
end

# Something that already exists is opened for editing, not recreated.
class ExistingTest < Minitest::Test
  include Runner

  def test_an_existing_page_is_reported_and_succeeds
    out, _err, code = new_page("page", "skincare/moisturizers")
    assert_equal 0, code
    assert_match(%r{^exists\s+blog/skincare/moisturizers\.md$}, out)
  end

  def test_an_existing_page_is_opened
    assert_equal ["blog/skincare/moisturizers.md"], opened("page", "skincare/moisturizers")
  end

  def test_an_existing_section_is_opened
    assert_equal ["blog/skincare/skincare.md"], opened("folder", "skincare")
  end

  # blog/gists/wsl.md declares `permalink: blog/gists/sh/wsl`, so the file is not
  # where the permalink implies. It still has to be found.
  def test_finds_a_page_whose_file_path_differs_from_its_permalink
    out, _err, code = new_page("-n", "page", "gists/sh/wsl")
    assert_equal 0, code
    assert_match(%r{^exists\s+blog/gists/wsl\.md$}, out)
  end

  # ...and it belongs under blog/gists/sh/ to match its breadcrumbs.
  def test_offers_to_move_it_under_the_folder_its_permalink_implies
    out, _err, = new_page("-n", "page", "gists/sh/wsl")
    assert_match(%r{^would move\s+blog/gists/wsl\.md -> blog/gists/sh/wsl\.md$}, out)
  end

  # blog/design/type/type.md sits inside its folder, which is one of the two
  # legitimate placements — it must be left exactly where it is.
  def test_does_not_move_an_index_that_is_already_conventional
    out, _err, = new_page("-n", "folder", "design/type")
    refute_match(/move/, out)
  end

  # blog/games/dungeons-n-dragons.md is the section at blog/games/dnd. Looking
  # up by filename alone would invent a second D&D section next to it.
  def test_finds_a_section_by_permalink_rather_than_filename
    assert_equal "Dungeons & Dragons", front_matter("page", "games/dnd/warlock", "Warlock")["parent"]
  end

  def test_does_not_invent_a_duplicate_section_index
    refute_includes written("page", "games/dnd/warlock", "Warlock"), "blog/games/dnd.md"
  end

  # blog/design/type/ keeps its index inside rather than one level up.
  def test_finds_a_section_index_that_sits_inside_its_folder
    assert_equal ["blog/design/type/type.md"], opened("folder", "design/type")
  end

  def test_nothing_is_written_when_it_already_exists
    before = File.read(File.join(BLOG, "skincare", "moisturizers.md"))
    new_page("page", "skincare/moisturizers")
    assert_equal before, File.read(File.join(BLOG, "skincare", "moisturizers.md"))
  end

  def test_there_is_no_way_to_force_an_overwrite
    _out, err, code = new_page("--force", "page", "skincare/moisturizers")
    refute_equal 0, code
    assert_match(/invalid option/, err)
    refute_match(/\.rb:\d+:in/, err, "should not print a backtrace")
  end
end

# A page and a sub-section index occupy the same path, so promoting one to the
# other must not touch the file — it only needs a directory for the children.
class PromoteToSectionTest < Minitest::Test
  include Runner

  PAGE = File.join(BLOG, "food", "#{SCRATCH}.md")
  DIR  = File.join(BLOG, "food", SCRATCH)

  def setup
    File.write(PAGE, <<~MD)
      ---
      title: Zz Scaffold Test
      permalink: blog/food/#{SCRATCH}
      parent: Food
      nav_order: 9
      ---

      # Zz Scaffold Test

      prose that must survive
    MD
  end

  def teardown
    FileUtils.rm_f(PAGE)
    FileUtils.rm_rf(DIR)
  end

  def test_makes_the_directory_for_an_existing_page
    out, _err, code = new_page("folder", "food/#{SCRATCH}")
    assert_equal 0, code
    assert_match(/^exists\s/, out)
    assert Dir.exist?(DIR), "children have nowhere to live"
  end

  def test_leaves_the_existing_file_byte_identical
    before = File.read(PAGE)
    new_page("folder", "food/#{SCRATCH}")
    assert_equal before, File.read(PAGE)
  end

  def test_is_idempotent
    2.times { new_page("folder", "food/#{SCRATCH}") }
    assert Dir.exist?(DIR)
  end

  def test_a_child_is_parented_to_the_promoted_page
    new_page("folder", "food/#{SCRATCH}")
    new_page("page", "food/#{SCRATCH}/gin", "Gin")

    fm = YAML.safe_load(
      File.read(File.join(DIR, "gin.md")).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1]
    )
    assert_equal "Zz Scaffold Test", fm["parent"]
    assert_equal "blog/food/#{SCRATCH}/gin", fm["permalink"]
  end

  def test_a_dry_run_makes_no_directory
    new_page("-n", "folder", "food/#{SCRATCH}")
    refute Dir.exist?(DIR)
  end
end

# Moving a page to match its permalink, for real.
class RelocateTest < Minitest::Test
  include Runner

  STRAY  = File.join(BLOG, "food", "#{SCRATCH}-stray.md")
  TARGET = File.join(BLOG, "food", SCRATCH, "stray.md")
  BODY   = <<~MD
    ---
    title: Stray
    permalink: blog/food/#{SCRATCH}/stray
    parent: Food
    nav_order: 9
    ---

    # Stray

    prose that must survive the move
  MD

  def setup
    FileUtils.mkdir_p(File.dirname(STRAY))
    File.write(STRAY, BODY)
  end

  def teardown
    FileUtils.rm_f(STRAY)
    FileUtils.rm_rf(File.join(BLOG, "food", SCRATCH))
  end

  def test_moves_the_file_to_where_its_permalink_points
    new_page("page", "food/#{SCRATCH}/stray")
    assert File.file?(TARGET), "not moved"
    refute File.exist?(STRAY), "left behind at the old path"
  end

  def test_content_survives_the_move_byte_for_byte
    new_page("page", "food/#{SCRATCH}/stray")
    assert_equal BODY, File.read(TARGET)
  end

  def test_a_dry_run_moves_nothing
    new_page("-n", "page", "food/#{SCRATCH}/stray")
    assert File.file?(STRAY)
    refute File.exist?(TARGET)
  end

  def test_running_twice_is_a_no_op
    2.times { new_page("page", "food/#{SCRATCH}/stray") }
    assert_equal BODY, File.read(TARGET)
  end

  # Never clobber: if something already sits at the destination, leave both alone.
  def test_refuses_to_move_onto_an_occupied_path
    FileUtils.mkdir_p(File.dirname(TARGET))
    File.write(TARGET, "already here\n")

    _out, err, = new_page("page", "food/#{SCRATCH}/stray")
    assert_match(/already taken/, err)
    assert_equal "already here\n", File.read(TARGET)
    assert File.file?(STRAY), "the stray file should still be there"
  end
end

# The only tests that touch the filesystem.
class WriteTest < Minitest::Test
  include Runner

  def teardown
    FileUtils.rm_rf(File.join(BLOG, SCRATCH))
    FileUtils.rm_f(File.join(BLOG, "#{SCRATCH}.md"))
  end

  def test_creates_the_section_and_the_page_in_one_command
    _out, err, code = new_page("page", "#{SCRATCH}/domain")
    assert_equal 0, code, err

    index = "#{BLOG}/#{SCRATCH}/#{SCRATCH}.md"
    page  = "#{BLOG}/#{SCRATCH}/domain.md"
    assert File.file?(index), "section index not written"
    assert File.file?(page),  "page not written"

    fm = YAML.safe_load(File.read(page).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1])
    assert_equal "Domain", fm["title"]
    assert_equal "blog/#{SCRATCH}/domain", fm["permalink"]
    assert_equal YAML.safe_load(File.read(index).match(/\A---\s*\n(.*?\n?)^---\s*\n/m)[1])["title"],
                 fm["parent"]
  end

  def test_dry_run_writes_nothing
    new_page("-n", "page", "#{SCRATCH}/domain")
    refute File.exist?("#{BLOG}/#{SCRATCH}/#{SCRATCH}.md")
  end

  def test_opens_every_file_it_creates
    assert_equal ["blog/#{SCRATCH}/#{SCRATCH}.md", "blog/#{SCRATCH}/domain.md"],
                 opened("page", "#{SCRATCH}/domain")
  end

  def test_a_dry_run_opens_nothing
    assert_empty opened("-n", "page", "#{SCRATCH}/domain")
  end

  def test_no_open_opens_nothing
    assert_empty opened("--no-open", "page", "#{SCRATCH}/domain")
  end
end
