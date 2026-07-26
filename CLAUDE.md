# picaq.github.io

Mandy's GitHub Pages site. A Jekyll blog plus several standalone vanilla HTML/CSS/JS
projects (`sarasa/`, `sleepytime/`, `bootstrap/`, `eventonica/`, …, some of them git
submodules — see `.gitmodules`). Almost all active work is in the blog.

- Jekyll docs — https://jekyllrb.com/docs/
- just-the-docs theme — https://github.com/just-the-docs/just-the-docs

## Running it

```sh
bundle exec jekyll s                                  # what the README says
bundle exec jekyll s --config _config.yml,_config_dev.yml   # skips remote_theme, much faster
```

`_config_dev.yml` is a two-line override that disables `remote_theme` so the local
`just-the-docs` gem is used instead of a network fetch. `_config.yml` is **not**
reloaded on rebuild — restart the server after editing it.

Ruby 3.4.3 (`.ruby-version`, rbenv). Jekyll 4.4.1, just-the-docs 0.10.1. No Node,
no `package.json`.

## Scaffolding new pages

```sh
bin/new-page                                            # interactive
bin/new-page page   internet/domain                     # section + page in one go
bin/new-page page   design/squint          "Squint Test"
bin/new-page recipe food/recipes/miso-soup "Miso Soup"
bin/new-page folder travel                 "Travel"     # new top-level section
bin/new-page folder internet/domain        "Domain"     # domain as a section instead
```

**The path you type is the permalink**, and the type decides what its last
segment means — for `page`/`recipe` it is the page itself, for `folder` it is a
section. Any section in the path that doesn't exist yet is created on the way,
so `page internet/domain` writes both `blog/internet/internet.md` and
`blog/internet/domain.md`.

`TITLE` is optional and defaults to the last segment, title-cased. Because the
slug comes from the path rather than the title, the two can differ, which is the
usual case here — `design/squint` with title `Squint Test`.

**Existing content is never overwritten.** There is no `--force`; the flag was
removed. Anything already there is opened rather than recreated, so the same
command works whether you're starting a page or going back to edit one.

Lookups match on `permalink`, not on file path — that's what finds
`blog/gists/wsl.md` from `gists/sh/wsl`, and `blog/games/dungeons-n-dragons.md`
from `games/dnd`. Matching on filename alone would quietly invent a second D&D
section beside the real one.

Two things follow from that:

- **A page found somewhere other than where its permalink points is moved there**
  (`git mv`, so history follows), one page at a time — only the one you name.
  Content and permalink are untouched, so the rendered URL is identical; only the
  tree changes, to match the breadcrumbs. A section index already sitting at
  either legitimate location is left alone.
- **Asking for an existing page as a folder just makes the directory.** A page and
  a sub-section index occupy the same path, so promoting one needs no file change
  at all — `folder food/drinks` creates `blog/food/drinks/` and leaves
  `blog/food/drinks.md` byte-identical.

Every file it writes is opened with `code`. Override with `NEW_PAGE_OPEN=vim`,
suppress for one run with `--no-open`, or turn it off entirely with
`NEW_PAGE_OPEN=`. `--dry-run` never opens anything.

Templates live in `_templates/` and are plain editable markdown. Placeholders are
literal `{{UPPERCASE}}` tokens swapped by string replacement, chosen so Liquid
survives untouched — `{% render_recipe %}` and `{% include toc.html %}` aren't
`{{...}}` at all, and `{{ site.title }}` has spaces and lowercase. A line whose
placeholder resolves to nothing is dropped, which is how `parent:` disappears on a
top-level section.

Jekyll ignores any path segment starting with `_` (`entry_filter.rb:59`), so
`_templates/` needs no `exclude:` entry.

## How the blog is actually structured

**It is not a Jekyll collection and does not use `_posts`.** `_posts/` holds only
the untouched default Jekyll file. Every blog page is an ordinary Jekyll page: a
plain `.md` in a plain directory under `blog/`, with an explicit `permalink`.

**Nav comes entirely from front matter** — `title` / `parent` / `nav_order`. This
has consequences that are easy to get wrong:

- `parent:` is a **string match against another page's `title:`**, not a path.
  It must match exactly, punctuation included (`parent: Dungeons & Dragons`).
  Titles are therefore effectively site-unique identifiers.
- **Where a file sits on disk is decorative.** `blog/gists/wsl.md` sits flat in
  `gists/` but declares `parent: Shell` and `permalink: blog/gists/sh/wsl`. All six
  D&D pages sit flat in `blog/games/` yet nest three deep in the nav. Ten pages
  currently disagree with their permalink this way; `bin/new-page` moves one into
  place when you name it, but nothing rewrites them in bulk.
- `has_children:` is **never used** — just-the-docs 0.10 infers it from any page
  declaring `parent:`. Don't add it.
- Child lists under a section index are generated by
  `{% include components/children_nav.html %}` in `_layouts/default.html`. That's
  why `blog/food/food.md` trails off with "…found here:" — the list follows on its
  own. Never hand-write one.
- `_config.yml` sets a site-wide default `layout: default`, so normal pages **omit
  `layout:` entirely**.
- The theme renders at most **3 nav levels**.

**Section indexes** follow two conventions, both live:

| | index location | examples |
|---|---|---|
| top-level | *inside* the folder | `blog/food/food.md`, `blog/skincare/skincare.md` |
| sub-section | one level *up* | `blog/food/recipes.md`, `blog/gists/css.md` |

`blog/design/type/type.md` is the exception — a sub-section using the inside
pattern. Any lookup must try inside first, then up.

**Adding a folder needs exactly one thing: a section-index `.md`.** No collection
config, no `_data/`, no nav file, no `_config.yml` edit. Confirmed by git history —
commit `060c2e4` ("start skincare section") touched exactly one file.

`blog/gists/python/` and `blog/gists/ruby/` are empty directories whose indexes sit
one level up. The blog landing page is **not** in `blog/` — it's `about.md` at the
repo root, with `permalink: /blog`.

## Conventions

- **Filenames:** kebab-case, no date prefixes, always `.md`.
- **Permalinks:** `blog/<segments>/<slug>` — no leading slash, no trailing slash, no
  `.html`. Jekyll emits `blog/food/recipes/miso-soup.html`.
- The slug is often deliberately **shorter than the filename**: `squint-test.md` →
  `blog/design/squint`, `shell.md` → `blog/gists/sh`, `dungeons-n-dragons.md` →
  `blog/games/dnd`. Recipes are the exception — filename matches slug for all 8.
  (`bin/new-page` takes the slug from the path, so this needs no extra flag.)
- **`nav_order`:** hand-assigned small int, **not unique and not sequential**.
  Recipes alone has four collision pairs. Ties break alphabetically by title, so
  collisions are harmless; never renumber siblings to "fix" them.
- **Links:** intra-folder links are bare relative slugs (`[cheesy peas](cheesy-peas)`);
  cross-section links are absolute (`/blog/food/recipes`).
- **Dates:** only recipe pages carry `date:`, formatted `2025-06-03 6:43:00 -0700`
  (unpadded hour). Feeds `jekyll-seo-tag` and the sitemap.
- **Typography is deliberate.** Curly apostrophes `’`, spaced en-dashes `–`,
  `&nbsp;` to bind pairs, spaces inside parens `( like this )`. Match it.

## Recipe pages

`layout: recipe` → `_layouts/recipe.html`, a copy of `default.html` whose `<main>`
carries `itemscope itemtype="http://schema.org/Recipe"` plus a hardcoded invisible
`AggregateRating`. The body is just `{% render_recipe %}`.

`_plugins/recipe_tag.rb` reads the front matter and emits **schema.org Microdata**.
The JSON-LD on the page is unrelated — generic `BlogPosting` from `jekyll-seo-tag`.

Fields it reads: `title` (**required** — `title.downcase` is unguarded at
`recipe_tag.rb:39`), `title_override`, `image`, `excerpt` (falls back to
`intro_blurb`, then `intro`), `description` (used only when `excerpt` is absent),
`prepmins`, `cookmins`, `yield`, `ingredients`, `ingredients_blurb` (falls back to
`ingredients_intro`), `instructions`, `result_blurb`, `nutrition`, `cuisine`,
`diet`, `category`, `keywords`. `excerpt` / `ingredients_blurb` / `result_blurb`
run through Kramdown GFM, so they accept markdown.

**The nutrition gate:** `recipe_tag.rb:83` renders the whole
cuisine/diet/category/keywords block only `if nutrition.any?`. A `nutrition:` block
with blank sub-keys still counts as present (`{"calories"=>nil}.any?` is `true`), so
it renders either way — to suppress it, delete the sub-keys and leave `nutrition:`
bare.

Also present on existing recipes but **not** read by the plugin: `thumbnail`,
`date`, `tags`.

`&#58;` is used in place of a literal `:` inside YAML scalars to dodge parse errors.
Images are hosted on `github.com/user-attachments/...`.

### Known bug in existing recipes

`cheesy-peas.md`, `spicy-cold-tofu.md`, and `natto-nacho-cheese.md` each declare
`tags:` **twice** — an inline array near the top and a block list near the bottom.
YAML silently keeps only the last, so the descriptive tags are dropped. Don't
replicate this; `_templates/recipe.md` has a single `tags:` line.

## Custom plugins

- `_plugins/recipe_tag.rb` — the `{% render_recipe %}` tag.
- `_plugins/add_first_letter_class.rb` — nokogiri hook adding a first-letter class
  to `h1`/`h2` for drop-cap styling.
- `_plugins/external_links.rb` — adds `target="_blank"` to external anchors,
  re-runs the first-letter pass, and NFC-normalizes output.

Custom styles are in `_sass/custom/custom.scss`. Note `.invisible` — used both for
schema-only spans and for `![image](...){:.invisible}` trailing images.

## Gotchas

- Local plugins in `_plugins/` **do not run on GitHub Pages'** built-in Jekyll. This
  repo deploys via its own Actions workflow (`.github/workflows/deploy.yml`) which
  runs `bundle exec jekyll build` and pushes `_site` to the `gh-pages` branch — that
  is what makes `{% render_recipe %}` work in production.
- That workflow pins **Ruby 3.1**, while `.ruby-version` is **3.4.3**. Local builds
  and CI are not on the same Ruby; keep new Ruby code inside 3.1-compatible syntax.
- Stale build output lives in `_site/`, `.jekyll-cache/`, `blog/*/.jekyll-cache/`,
  and `blog/food/recipes/_site/`. All gitignored — ignore them when searching.
- `last_edit_timestamp: true` is set, but it only shows for pages defining
  `last_modified_date`, and no page currently does.
