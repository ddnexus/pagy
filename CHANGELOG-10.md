---
icon: versions-24
---

# CHANGELOG

## Release Policy

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/), and introduces BREAKING CHANGES only for MAJOR versions.

We release any new version (MAJOR, MINOR, PATCH) as soon as it is ready for release, regardless of any time constraint, frequency
or duration.

We rarely deprecate elements (releasing a new MAJOR version is just simpler and more efficient). However, when we do, you can
expect the old/deprecated functionality to be supported ONLY during the current MAJOR version.

## Recommended Version Constraint

Given a version number `MAJOR.MINOR.PATCH` (e.g. `10.0.0`):

The `gem 'pagy', '~> 10.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAJOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

## Breaking Changes

If you upgrade from version `< 10.0.0` see the following:

- [Breaking changes in version 10.0.0](#version-1000)
- [Breaking changes in version 9.0.0](CHANGELOG_LEGACY.md#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY.md#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY.md#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

None

<hr>

## Version 10.0.0

### Overview

This version is a complete redesign of the legacy code, and its API will be stable for a long time.

- Reduce the required config by **99%**: no require, no extras, no DEFAULT
- All the methods are **autoloaded only if you use them**
- More explicit naming: less docs to read to understand what a method does
- The code structure and naming is cleaner, more concise, readable, and consistent
- The new docs are short and to the point, easy to browse and understand
- You can also get valuable real-time support with the new Pagy AI

### New features

- **Keynav Pagination**
  - We invented the pagy-exclusive `keynav` pagination, that uses the fastest `keyset` technique with all the Frontend helpers.
    The best technique for performance and functionality!
- **The Countless pagination remembers the last page**
  - When you jump back a few pages in the pagination nav, you can jump forward as well now.
- **Javascript refactoring**
  - The new `Pagy.sync_javascript_source` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map files.
  - Updated the support for all the pagy helpers and `keynav` pagination.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when your app uses them.
  - You can easily override the lookup of locale files with `Pagy::I18n::PATHNAMES.unshift(my_dictionaries)`.
- **Simpler overriding**
  - The logic of helpers and paginators methods is simpler to understand and override in your own app code.
  - You won't even need to know anything about the implementation classes.
- **Cleaner URLs**
  - The `pagy_page_url` (legacy `pagy_url_for`) can be used also without a request (incorporating the legacy `standalone` extra)
  - No more empty params or extra '?' in the URL string
  - URL templates are safer and easier for string manipulation.

### Breaking Changes / Updating Guide

#### Simple search and replace renaming (without logic changes)

These renamings implement a consistent logic throughout the gem, aimed to avoid confusion and to improve readability and
understanding.

_Notice that your app will likely use a little fraction of the list below_

{.compact}

| Type        | Search (old)         | Replace with (new) | Why?                                                                                      |
|-------------|----------------------|--------------------|-------------------------------------------------------------------------------------------|
| Constructor | `pagy(`              | `pagy_offset(`     | Because it's consistent with the other old and new paginator methods                      |
| Function    | `Pagy.root`          | `Pagy::ROOT`       | Because we don't need to call a method just to get a constant Pathname                    |
| Accessor    | `pagy.vars`          | `pagy.options`     | Because they are actually `options` that don't change during execution                    |
| Exception   | `VariableError`      | `OptionError`      | Because it's consistent with the `options` argument                                       |
| Accessor    | `e.variable`         | `e.option`         | Because it's consistent with its `OptionError` class                                      |
| Method      | `pagy_anchor(pagy`   | `pagy.a_lambda(`   | Because it creates a lambda, not the a tag itself, and it's a pagy instance method        |
| Method      | `pagy_url_for(@pagy` | `@pagy.page_url(`  | Because `_url_for` suggests diversifiable results, and rails-related expectations         |
| Method      | `pagy_t`             | `I18n.translate`   | Because we don't use abbreviated words anymore, and it's exactly like with the I18n gem   |
| Naming      | `*prev*`             | `*previous*`       | Because we don't use abbreviated words anymore (check: option, accessor, methods, CSS)    |
| Option      | `size: 7`            | `length: 7`        | Because it's the linear `length` of the `series`, and avoids confusion with other `size`s |
| Option      | `ends: false`        | `compact: true`    | Because it's an opt-in option of the `series`, boolean inverse of `ends`                  |
| Option      | `:page_param`        | `:page_sym`        | Because `page_param` make people think "page param value"                                 |
| Option      | `:limit_param`       | `:limit_sym`       | Because `limit_param` make people think "limit param value"                               |
| Method/args | `label_for`          | `page_label`       | Because `_for` suggests diversifiable results                                             |
| Method/args | `label`              | `page_label`       | Because we don't need two methods                                                         |

#### Replace your `pagy.rb` config file

With no more `Pagy::DEFAULT` and no more extras to `require`, all the statements in your old version are obsolete, so it's better
to start with the new version of the file.

#### The `Pagy::DEFAULT` is now frozen

- The `Pagy::DEFAULT` is now an internal hash and it's frozen. If you set any option with it, you should pass them to the
  paginator methods.
- As an alternative to avoid repetitions, define your own `PAGY_OPTIONS` hash and pass it to the different paginator
  methods/helpers. See the new `pagy.rb` initializer for details.

#### The `Pagy::Backend` has been replaced by `Pagy::Paginators`

- Replace the `include Pagy::Backend` with `include Pagy::Paginators`
- All the old **paginators** (i.e. the one returning pagy, and records) are still backend method
- Just one change: `pagy(` is now `pagy_offset(` for consistency with the other old and new paginator methods
- See how to deal with other helpers added by extras in the [Extras Changes](#extras-changes)

#### The `Pagy::Frontend` is gone

- Frontend methods returning HTML code are now `@pagy` instance methods. Easier and cleaner.
- Remove any existing `include Pagy::Frontend`
- You should convert all the existing `pagy_*` methods **ONLY in the views**.
- See the [Extras Changes](#extras-changes) for a details

#### Core changes

- If you used the `:params` variable set to a lambda, ensure that it modifies the passed `query_params` directly.
  - The returned value is now ignored for a slightly better performance.
- The `:outset` and `:cycle` variables have been removed.
  - They were seldom used, mostly useless, and implementing them in your own code is trivial.
- You should pass the `:length` and `:compact` options (legacy `:size` and `ends`), _preferably_ to the `*_nav`, `*_nav_js`
  helpers, but it's also possible to pass them to the paginator methods.

#### Extras Changes

All the extras are gone. Here is what to do in order to accomodate the changes:

- Remove all `require 'pagy/extras/*` statements from the `pagy.rb` initializer.

##### `array`

- Just use the method without further changes.

##### `arel`

- Replace `pagy_arel` with `pagy_offset` and add `count_over: true` to the existing options.

##### `boostrap`

- Replace any existing `pagy_bootstrap_nav(@pagy` with `@pagy.nav_tag(style: :bootstrap`
- Replace any existing `pagy_bootstrap_nav_js(@pagy` with `@pagy.nav_js_tag(style: :bootstrap`
- Replace any existing `pagy_bootstrap_combo_nav_js(@pagy` with `@pagy.combo_nav_js_tag(style: :bootstrap`

##### `bulma`

- Replace any existing `pagy_bulma_nav(@pagy` with `@pagy.nav_tag(style: :bulma`
- Replace any existing `pagy_bulma_nav_js(@pagy` with `@pagy.nav_js_tag(style: :bulma`
- Replace any existing `pagy_bulma_combo_nav_js(@pagy` with `@pagy.combo_nav_js_tag(style: :bulma`

##### `pagy` (and all helpers)

- All the old helpers are now `@pagy` instance methods with more explicit names (e.g. `_tag`)

| Search (old)                   | Replace with (new)             |
|--------------------------------|--------------------------------|
| `pagy_nav(@pagy`               | `@pagy.nav_tag(`               |
| `pagy_nav_js(@pagy`            | `@pagy.nav_js_tag(`            |
| `pagy_combo_nav_js(@pagy`      | `@pagy.combo_nav_js_tag(`      |
| `pagy_info(@pagy`              | `@pagy.info_tag(`              |
| `pagy_limit_selector_js(@pagy` | `@pagy.limit_selector_js_tag(` |
| `pagy_prev_url(@pagy`          | `@pagy.previous_url(`          |
| `pagy_next_url(@pagy`          | `@pagy.next_url(`              |
| `pagy_prev_link(@pagy`         | `@pagy.previous_link_tag(`     |
| `pagy_next_link(@pagy`         | `@pagy.next_link_tag(`         |
| `pagy_prev_a(@pagy`            | `@pagy.previous_a_tag(`        |
| `pagy_next_a(@pagy`            | `@pagy.next_a_tag(`            |

##### `countless`

- Rename any existing `:countless_minimal` to `:headless`.
- Keep the rest unchanged.

##### `calendar`

- Discard your old localization config (if any), and uncomment and customize this line in the `pagy.rb` initializer:
  `Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)`.
  - _Notice: In non-rails apps, calendar localization requires to add `rails-i18n` to your Gemfile._
- Replace the existing (if any) `Pagy::Calendar::OutOfRangeError` with `Pagy::RangeError`.
- Keep the rest unchanged.

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- **Active and passive modes are now handled by the same paginator method.**
  - Replace any existing `Pagy.new_from_<extra-name>` with `pagy_<extra-name>`.
- **The name customization of the `pagy_search` has been discontinued.**
  - Remove any existing `:<extra-name>_pagy_search` variable from your code.
  - Replace your existing custom method name with the standard `pagy_search` method instead.
- Rename any existing `:<extra-name>_search` variable to `:search_method` and pass it to the paginator method.
- Keep the rest unchanged.

##### `headers`

- Remove any existing `pagy_headers_merge`. Merge it with `response.headers.merge!(@pagy.headers_hash(**))`
- Pass your `:headers` option _preferably_ to the `headers_hash` helper method, but you can also pass it to the paginator
  method, although is less direct. 

##### `jsonapi`

- Rename any existing `pagy_jsonapi_links` to `pagy_links_hash`.
  - _Notice that the `nil` links are now removed as the `JSON:API` specifications require._
- Enable the feature by passing the `jsonapi: true` option to the paginator method.

##### `keyset`

- Replace any existing `:jsonify_keyset_attributes` with `stringify_keyset_values`.
  - The lambda receives the same `keyset_attributes` argument, but it must return the array of attribute values.
    `->(keyset_attributes) { ...; keyset_attributes.values }`.
- Remove any existing`:filter_newest`. Override the `compose_predicate` method instead.

##### `limit`

- Rename the existing `:limit_param` to `:limit_sym`
- Delete the existing `:limit_max` and `:limit_extra`
- Enable the feature by passing `requestable_limit: your_max_limit` option to the paginator method.

##### `metadata`

- Rename `pagy_metadata` to `@pagy.pluck_hash` (renamed because it's what it does and return).
- Rename any existing `:scaffold_url` to `url_template` (renamed because it's a template string).
- Rename any existing `:metadata` option to `:keys` (renamed because they are keys).
- Pass your `:keys` array _preferably_ to the `pluck_hash` helper method, but you can also pass it to the paginator
  method, although is less direct.

##### `overflow`

- The `Pagy::OverflowError` has been replaced by the `Pagy::RangeError`, however it is not raised by default as before.
- Pagy rescues the `Pagy::RangeError` and serves an empty page by default.
  - Now pagy works the same as it would have worked before by requiring the overflow extra and using its default.
- The legacy `pagy.overflow?` is now `pagy.in_range?` method: it checks/returns the opposite state/boolean.
- The `overflow: :last_page` option has been discontinued because it provides almost no benefit (read below how to do it anyway):
  - **Why there is almost no benefit in serving the last page**
    - The nav bar of an out-of-range request is rendered with the same links rendered for the last page.
    - The difference is just that there are no records/results to show.
    - The previous page button points to the last page, so if the users really want to see the last page results (which they have
      already seen, BTW), they can just use the link.
- **Summary**:
  - If you used no extra (i.e. pagy raised errors): set `raise_range_error: true`.
  - If you used `overflow: :empty_page ` or just required the overflow extra: just remove it (it's the current default now).
  - If you used `overflow: :last_page` and you really want it despite what explained before:
    - Set `raise_range_error: true`.
    - Use `rescue Pagy::RangeError => e` in your method.
    - Redirect to `pagy_page_url(pagy, pagy.last)`.

##### `standalone`

- Replace the `:url` variable with `:request` _(which can also handle the query_params now)_.
- For example: `request: { url_prefix: 'the-previous-value-of-url', query_params: { param1: 'abc', param2: 'def' }}`.

##### `i18n`

- If you really need it, uncomment/add this line to your initializer: `Pagy::Frontend.translate_with_the_slower_i18n_gem!`.

##### `gearbox` (discontinued feature)

- The feature requires so much overwriting for so little difference that you can just remove it from your app, and nobody will
  even notice.

##### `size` (discontinued feature)

- Pagination bars similar to WillPaginate and Kaminari are not good for a lot of reasons. If you still want it, you can adapt the
  legacy file from an old commit.

##### `trim` (discontinued feature)

- It was mostly useless and half-backed, causing a lot of complications in the ruby and javascript code for no real benefit.
- Use a proper way to address your requirement, like using URL rewriting at the HTTP server level.

#### Direct instantiation of the pagy classes is not recommended

- The provided paginators methods ensure easier usage, maintenance and forward compatibility.
- Use the implementing classes only if the documentation explicitly suggests you to do so, or if you know what you are doing.

#### Possibly Breaking Overridings

- The internal Pagy protected methods have been all refactored, often renamed, and sometimes removed.
- If you use custom Pagy classes, you need to reconcile them by looking into the new pagy code.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
