# frozen_string_literal: true

# Runs every test file.
#
#   ruby test/all.rb
#
# Plain ruby, not `bundle exec` — minitest ships with ruby but is not in the
# Gemfile. rendered_html_test.rb shells out to `bundle exec jekyll build` itself
# when _site is missing or stale.

Dir.glob("#{__dir__}/*_test.rb").sort.each { |file| require file }
