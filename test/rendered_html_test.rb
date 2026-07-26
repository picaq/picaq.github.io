# frozen_string_literal: true

# Tests against the rendered site rather than the source.
#
#   ruby test/rendered_html_test.rb
#
# Builds _site first if it is missing or older than the sources. This is the
# right place to check links: a page's file can move without its permalink
# changing, so only the rendered output says whether a link actually resolves.

require "minitest/autorun"
require "yaml"
require "date"
require "open3"

# Constants live in the module so this file can be loaded alongside the others.
module Site
  ROOT = File.expand_path("..", __dir__)
  SITE = File.join(ROOT, "_site")
  BLOG = File.join(ROOT, "blog")

  # Sibling GitHub Pages projects. They live at picaq.github.io/<name>/ but are
  # built from their own repos, so they are legitimately absent from this _site.
  # /notation-map/ answers 200 in production; it just isn't ours to build.
  SEPARATE_PROJECTS = %w[notation-map epa-uv recipe-page JS-HTML-Games].freeze

  # Vanilla HTML projects vendored here, several of them git submodules that are
  # not checked out by the deploy workflow. Not this blog's markup to police.
  VENDORED = %w[
    sarasa sleepytime bootstrap eventonica portfolio
    kimcheese-boots kimcheese-recipe JS+HTML-Games assets
  ].freeze

  def self.newest_source
    Dir.glob("#{ROOT}/{blog,_layouts,_includes,_plugins,_sass}/**/*")
       .push("#{ROOT}/_config.yml")
       .select { |f| File.file?(f) }
       .map    { |f| File.mtime(f) }
       .max
  end

  def self.build_if_stale
    landing = "#{Site::SITE}/index.html"
    return if File.file?(landing) && File.mtime(landing) >= newest_source

    puts "building _site ..."
    _out, err, status = Open3.capture3(
      "bundle", "exec", "jekyll", "build", "--config", "_config.yml,_config_dev.yml", chdir: ROOT
    )
    raise "jekyll build failed:\n#{err}" unless status.success?
  end

  # Only the pages Jekyll renders from this blog's markdown: not the vendored
  # standalone projects, whose markup isn't maintained here.
  def self.rendered_pages
    Dir.glob("#{Site::SITE}/blog/**/*.html") + ["#{Site::SITE}/blog.html", "#{Site::SITE}/index.html"].select { |f| File.file?(f) }
  end

  def self.source_front_matter
    Dir.glob("#{BLOG}/**/*.md").push(*Dir.glob("#{ROOT}/*.md")).filter_map do |file|
      match = File.read(file).match(/\A---\s*\n(.*?\n?)^---\s*\n/m) or next
      fm = begin
        YAML.safe_load(match[1], permitted_classes: [Date, Time, Symbol]) || {}
      rescue StandardError
        next
      end
      next if fm["permalink"].to_s.empty?

      [file.delete_prefix("#{ROOT}/"), fm]
    end
  end

  # href -> the file it should resolve to, or nil if it isn't ours to check.
  def self.resolve(href, from_page)
    return nil if href.empty? || href.start_with?("#")
    return nil if href.match?(%r{\A(https?:|mailto:|tel:|javascript:|data:|//)})

    path = href.split("#").first.to_s.split("?").first.to_s
    return nil if path.empty?

    first = path.delete_prefix("/").split("/").first
    return nil if path.start_with?("/") && (SEPARATE_PROJECTS + VENDORED).include?(first)

    base = path.start_with?("/") ? File.join(Site::SITE, path) : File.join(File.dirname(from_page), path)
    File.expand_path(base)
  end

  def self.resolves?(target)
    File.file?(target) || File.file?("#{target}.html") || File.file?(File.join(target, "index.html"))
  end
end

Site.build_if_stale

class RenderedLinkTest < Minitest::Test
  def broken_links
    Site.rendered_pages.flat_map do |page|
      File.read(page).scan(/<a\b[^>]*\shref=["']([^"']+)["']/i).flatten.filter_map do |href|
        target = Site.resolve(href, page)
        next if target.nil? || Site.resolves?(target)

        "#{page.delete_prefix("#{Site::SITE}/")}  ->  #{href}"
      end
    end.uniq.sort
  end

  def test_every_internal_link_resolves_to_a_real_page
    assert_empty broken_links, "links that do not resolve in _site"
  end

  def test_there_are_links_to_check_at_all
    # Guards against the checker silently passing because it found nothing.
    count = Site.rendered_pages.sum do |page|
      File.read(page).scan(/<a\b[^>]*\shref=["']([^"']+)["']/i).flatten.count do |href|
        !Site.resolve(href, page).nil?
      end
    end
    assert_operator count, :>, 100, "expected the blog to have plenty of internal links"
  end
end

# The script relies on permalinks being unique and on every page emitting a file,
# so both are worth asserting directly.
class PermalinkTest < Minitest::Test
  def test_every_permalink_produces_an_output_file
    missing = Site.source_front_matter.reject do |_file, fm|
      Site.resolves?(File.join(Site::SITE, fm["permalink"].to_s.delete_prefix("/")))
    end.map { |file, fm| "#{file}  ->  #{fm["permalink"]}" }

    assert_empty missing, "permalinks with no rendered page"
  end

  def test_no_two_pages_claim_the_same_permalink
    by_permalink = Site.source_front_matter.group_by { |_file, fm| fm["permalink"].to_s.delete_prefix("/").chomp("/") }
    clashes = by_permalink.select { |_permalink, entries| entries.size > 1 }
                          .map { |permalink, entries| "#{permalink}: #{entries.map(&:first).join(", ")}" }

    assert_empty clashes, "two pages rendering to the same URL would silently overwrite each other"
  end
end

# The property that made this file worth writing: moving a page's file must not
# change its URL, because the permalink is explicit front matter.
class MoveSafetyTest < Minitest::Test
  def test_output_path_follows_the_permalink_not_the_source_path
    mismatched = Site.source_front_matter.reject do |file, fm|
      implied = "blog/#{file.delete_prefix("blog/").sub(/\.md\z/, "")}"
      fm["permalink"].to_s.delete_prefix("/") == implied
    end

    # Ten pages currently sit somewhere other than their permalink implies. Each
    # must still render at its permalink, which is what makes relocating safe.
    refute_empty mismatched, "expected this blog to still have some of these"
    mismatched.each do |file, fm|
      assert Site.resolves?(File.join(Site::SITE, fm["permalink"].to_s.delete_prefix("/"))),
             "#{file} does not render at #{fm["permalink"]}"
    end
  end
end
