---
icon: versions-24
---

# CHANGELOG

## Release Policy

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/), and introduces BREAKING CHANGES only for MAYOR versions.

We release any new version (MAJOR, MINOR, PATCH) as soon as it is ready for release, regardless of any time constraint, frequency
or duration.

We rarely deprecate elements (releasing a new MAYOR version is just simpler and more efficient). However, when we do, you can
expect the old/deprecated functionality to be supported ONLY during the current MAYOR version.

## Recommended Version Constraint

Given a version number `MAJOR.MINOR.PATCH` (e.g. `10.0.0`):

The `gem 'pagy', '~> 10.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAYOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

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

- Simplify the usage maintenance substantially
- Reduce the required config by 99%: no require, no extras, no DEFAULT
- Reduce and improve all the methods, now autoloaded only if you actually use them, saving memory
- The code structure and naming is cleaner, more concise, readable, and consistent
- The new docs are short and to the point, easy to browse and understand
- You can also get valuable real-time support with the new Pagy AI
- Improve features, performance and memory usage

### New features

- **Keynav Pagination**
  - We add the pagy-exclusive `keynav` pagination, that uses the fastest `keyset` technique with all the Frontend helpers. The
    best technique for performance and functionality!
- **The Countless pagination remembers the last page**
  - When you jump back a few pages in the pagination nav, you can jump forward as well now.
- **Javascript refactoring**
  - The new `Pagy::Javascript.sync_source` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map.
  - Updated the support for all the pagy helpers and `keynav` pagination.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when you app uses them.
  - You can easily override the lookup of locale files with `Pagy::I18n::PATHNAMES.unshift(my_dictionaries)`.
- **Simpler overriding**
  - The logic of helpers and paginators methods is simpler to understand and override in your own app code.
  - You won't even need to know anything about the implementation classes.
- **Cleaner URLs**
  - The `pagy_page_url` (legacy `pagy_url_for`) can be used also without a request (incorporating the legacy `standalone` extra)
  - No more empty params or extra '?' in the URL string
  - URL templates are safer and easier for string manipulation.

### Breaking Changes (updating guide)

#### Simple search and replace renaming (without logic changes)

This implements a consistent naming logic throughout the gem, to improve readability and understanding.

| Type        | Search           | Replace                | Why?                                                                                      |
|-------------|------------------|------------------------|-------------------------------------------------------------------------------------------|
| Constructor | `pagy(`          | `pagy_offset(`         | Because it's consistent with the other old and new paginator methods                      |
| Function    | `Pagy.root`      | `Pagy::ROOT`           | Because we don't need to call a method just to get a constant Pathname                    |
| Accessor    | `pagy.vars`      | `pagy.options`         | Because they are actually `options` that don't change during execution                    |
| Exception   | `VariableError`  | `OptionError`          | Because it's consistent with the `options` argument                                       |
| Accessor    | `e.variable`     | `e.option`             | Because it's consistent with its class                                                    |
| Method      | `pagy_anchor`    | `pagy_anchor_lambda`   | Because it creates a lambda, not the anchor tag itself                                    |
| Method      | `pagy_url_for`   | `pagy_page_url`        | Because it's better for simple arguments, and avoids rails-related expectations           |
| Method/args | `label_for(page` | `label(page: page`     | Because it's better for simple arguments, and `page` is now a keywork argument            |
| Method/args | `label(page`     | `label(page: page`     | Because we don't need two methods, and `page` is now a keywork argument                   |
| Method      | `pagy_t`         | `pagy_translate`       | Because we don't use abbreviated words anymore                                            |
| Method      | `pagy_prev_a`    | `pagy_previous_anchor` | Because we don't use abbreviated words anymore                                            |
| Method      | `pagy_next_a`    | `pagy_next_anchor`     | Because we don't use abbreviated words anymore                                            |
| Naming      | `*prev*`         | `*previous*`           | Because we don't use abbreviated words anymore (check: option, accessor, methods, CSS)    |
| Option      | `size: 7`        | `length: 7`            | Because it's the linear `length` of the `series`, and avoids confusion with other `size`s |
| Option      | `ends: false`    | `compact: true`        | Because it's an opt-in option of the `series`, boolean inverse of `ends`                  |
| Option      | `:page_param`    | `:page_sym`            | Because the '_param' could be confused with the actual param value                        |
| Option      | `:limit_param`   | `:limit_sym`           | Because the '_param' could be confused with the actual param value                        |

#### Replace your `pagy.rb` config file

With no more `Pagy::DEFAULT` and no more extras to `require`, all the statements in your old version are obsolete, so it's better
to start with the new version of the file.

#### The `Pagy::DEFAULT` is now frozen

- The `Pagy::DEFAULT` is now an internal hash and it's frozen. If you set any option with it, you should pass them to the
  paginator methods.
- As an alternative to avoid repetitions, define your own `PAGY_OPTIONS` hash and pass it to the different paginator
  methods/helpers. See the new `pagy.rb` initializer for details.

#### Core changes

- If you used the `:params` variable set to a lambda, ensure that it modifies the passed `query_params` directly.
  - The returned value is now ignored for a sligtly better performance.
- The `:outset` and `:cycle` variables have been removed.
  - They were seldom used, mostly useless, and implementing them in your own code is trivial.
- You can pass the `:length` and `:compact` options (legacy `:size` and `ends`), preferably to the `*_nav`, `_nav_js` helpers, but
  it's also possible to pass them to the paginator.

#### Extras Changes

All the extras are gone. Here is what to do in order to accomodate the changes, besides removing all their `require`s from the
`pagy.rb` initializer:

##### `arel`, `array`, `boostrap`, `bulma`, `countless`, `pagy`

- Just use their features without further changes.

##### `calendar`

- Discard your old localization config (if any), and uncomment this line in the `pagy.rb` initializer:
  `Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)`.
  - _Notice: In non-rails apps, calendar localization requires to add `rails-i18n` to your Gemfile._
- Replace the existing (if any) `Pagy::Calendar::OutOfRangeError` with `Pagy::RangeError`

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- Replace any existing `Pagy.new_from_<extra-name>` with `pagy_<extra-name>`.
  - _Active and passive modes are now handled by the same paginator method._
- Remove any existing `:<extra-name>_pagy_search` variable from your code, and use the standard `pagy_search` method instead.
  - _The name customization of the `pagy_search` has been discontinued._
- Rename any existing `:<extra-name>_search` variable as `:search_method` and pass it to the paginator method.

##### `headers`

- Rename any existing `:headers` option to `:header_names` (indeed it's a hash, mapping headers to names)
- Pass your `:header_names`  _preferably_ to the `header_names` helper method, but you can also pass it to the paginator method.

##### `jsonapi`

- Rename any existing `pagy_jsonapi_links` as `pagy_links`.
  - _Notice that the `nil` links are now removed as the `JSON:API` specifications require._
- Enable the feature by passing the `{ jsonapi: true }` option to the paginator method.

##### `keyset`

- Replace any existing `:jsonify_keyset_attributes` with `stringify_keyset_values`
  - The lambda receives the same `keyset_attributes` argument, but it must return the array of attribute values
    `->(keyset_attributes) { ...; keyset_attributes.values }`.
- Remove any existing`:filter_newest`. Override the `compose_predicate` method instead.

##### `limit`

- Enable the feature by passing `{ requestable_limit: your_max_limit }` variable to the paginator method.

##### `metadata`

- Rename `pagy_metadata` to `pagy_data` (indeed it's just pagy data)
- Rename any existing `:scaffold_url` to `url_template`
- Rename any existing `:metadata` option to `:data_keys`
- Pass your `:data_keys` array _preferably_ to the `pagy_data` helper method, but you can also pass it to the paginator method.

##### `overflow`

- The `Pagy::OverflowError` has been replaced by the `Pagy::RangeError`, however it is not raised by default as before.
- Pagy rescues the `Pagy::RangeError` and serves an empty page by default. 
  - Now it works the same as requiring the legacy extra and using its default.
- The legacy `pagy.overflow?` is now `pagy.in_range?` method: it returns the opposite boolean.
- The `{ overflow: :last_page }` has been discontinued because it provides almost no benefit (read below how to do it anyway):
  - **Why there is almost no benefit in serving the last page**
    - The nav bar of an out-of-range request is rendered with the same links rendered for the last page
    - The difference is just that there are no records/results to show.
    - The previous page button points to the last page, so if the users really want to see the last page results (which they have
      already seen BTW), they can just click on the link.
- So, here is how to get the old behavior with the new implementation:
  - If you used no extra (i.e. pagy raised errors): set `{ raise_range_error: true }`
  - If you used `{ overflow: :empty_page }` or just required the overflow extra: just remove it (it's the current default now)
  - If you used `{ overflow: :last_page }` and you really want it:
    - Set `{ raise_range_error: true }`
    - Use `rescue Pagy::RangeError => e` in your method
    - Redirect to `pagy_page_url(pagy, pagy.last)`

#### `standlone`

- Replace the `:url` variable with `:request` _(which can also handle the query_params now)_.
- For example: `request: { url_prefix: 'the-previous-value-of-url', query_params: { param1: 'abc', param2: 'def' }}`

##### `i18n`

- If you REALLY need it, uncomment/add this line to your initializer: `Pagy::Frontend.translate_with_the_slower_i18n_gem!`

##### `gearbox` (discontinued feature)

- The feature requires so much overwriting for so little difference that you better just remove it from your app, and nobody will
  even notice.

##### `size` (discontinued feature)

- Pagination bars similar to WillPaginate and Kaminari are not good. If you still want it, you can adapt the legacy file from an
  old commit.

##### `trim` (discontinued feature)

- It was mostly useless and half backed, causing a lot of complications in the ruby and javascript code for no real benefit.
- Use a proper way to address your requirement, like using URL rewriting at the HTTP server level.

#### Direct instantiation of the pagy classes is not recommended

- Use the provided paginators methods for easier usage, maintenance and forward compatibility.
- Use the implementing classes only if the documentation explicitly suggests you to do so, or if you know what you are doing.

#### Possibly Breaking Overridings

- The internal Pagy protected methods have been all refactored, often renamed, and sometimes removed.
- If you use custom Pagy classes, you need to look into the pagy code.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
