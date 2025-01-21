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

This is a mayor, MAYOR version, with important additions and improvements, a lot easier to use and customize, it has fewer methods
and variables, cleaner code with a brand-new documentation and the new `Pagy AI`, ready to answer your questions.

### Keynav Pagination Addition

We just invented the `keynav` pagination: the pagy-exclusive technique to use `keyset` pagination with `pagy_*navs` and other
Frontend helpers. The best technique for performance AND functionality!

### Improvements

#### Automatic loading of just the code that you actually use

Every class, module and helper is automatically loaded only if you actually use it, without the need of any explicit `require`. _(
the legacy version was requiring more code)_

#### Better file and namespace system organization

The class hierarchy, the mixin files, and the test file structure have been deeply reorganized. The code is cleaner, more concise
and more readable, adding fewer modules to the `ancestors` array of your app.

#### The extras are almost all gone

They have been converted to autoloaded mixins, or integrated in the core code at zero-cost. You can use the methods that you need,
and they will just work without the need of any explicit `require`.

The only extras that are left _(for different compelling reasons)_ are: `gearbox`, `i18n` and `size`. They must be required in the
initializer as usual.

#### The Pagy::Countless remembers the last page

When you jump back a few pages in the pagination nav, it remembers the last page count, so you can jump forward as well now.

#### Cleaner URLs

- No more empty params or extra '?' in the url string URL templates are safer for string manipulation.
- The `pagy_page_url` (legacy `pagy_url_for`) can be used also without a request (incorporating the legacy `standalone` extra)

#### Javascript refactoring

Updated the support for the pagy helpers and keynav pagination. Added the plain `pagy.js` and relative source map.

### Breaking Changes

#### The `Pagy::DEFAULT` is now frozen

- Remove all the `Pagy::DEFAULT` variables from your code and pass their variables to the paginator method.
- As an alternative to avoid repetitions, define your own `PAGY_DEFAULT = {...}` hash and pass it to the different paginator
  methods:
  For example: `pagy_offset(scope, **PAGY_DEFAULT, ...)`

#### Direct instantiation of the pagy paginator method classes is not recommended

- Use the provided paginator method helpers for easier usage, maintenance and forward compatibility.

#### Simple renaming (without logic changes)

| Type        | Search         | Replace         | Notes                                                    |
|-------------|----------------|-----------------|----------------------------------------------------------|
| Variable    | `:page_param`  | `:page_sym`     | It was confusing                                         |
| Variable    | `:limit_param` | `:limit_sym`    | It was confusing                                         |
| Function    | `Pagy.root`    | `Pagy::ROOT`    | It's just a Pathname object                              |
| Constructor | `pagy(`        | `pagy_offset(`  | Consistent with the other old and new constructors       |
| Method      | `pagy_url_for` | `pagy_page_url` | The legacy naming was causing rails-related expectations |

#### Core changes

- If you used the `:params` variable set to a lambda, ensure that it modifies the passed `query_params` directly. The returned
  value is now ignored for a sligtly better performance.

#### Extras Replacement

##### `arel`, `array`, `boostrap`, `bulma`, `calendar`, `countless`, `pagy`

- Just remove the `require 'pagy/extras/<extra-name>'` from the initializer, and continue to use their features without further
  changes.

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- Remove the `require 'pagy/extras/<extra-name>'` from the initializer
- Replace any existing `Pagy.new_from_<extra-name>` with `pagy_<extra-name>`. _(Active and passive modes are now handled by the
  same helper.)_
- Replace any existing `extend Pagy::Search` statement in your models with `extend Pagy::Offset::Search`.
- Remove any existing `:<extra-name>_pagy_search`
  variable from your code, and use the standard `pagy_search` method instead. _(the `pagy_search` name customization has been
  discontinued.)_
- Rename any existing `:<extra-name>_search` variable as `:search_method` and pass it to the paginator method.

##### `headers`

- Remove the `require 'pagy/extras/headers'` from the initializer.
- Rename any existing `:scaffold_url` to `url_template`
- Remove any existing `Pagy::DEFAULT[:metadata]` variable and pass it to the paginator method

##### `jsonapi`

- Remove the `require 'pagy/extras/jsonapi'` from the initializer.
- Rename `pagy_jsonapi_links` as `pagy_links`. Notice that the `nil` links are now removed as the `JSON:API`
  requires.
- You should pass the `:jsonapi` variable to the paginator method when you want to trigger the feature.

##### `keyset`

- Remove the `require 'pagy/extras/keyset'` from the initializer.
- Replace any existing `:jsonify_keyset_attributes` with `stringify_keyset_values`. The lambda receives the same
  `keyset_attributes` but it must return the array of attribute values `->(keyset_attributes) { ...; keyset_attributes.values }`.
- Remove any existing`:filter_newest`. Override the `after_cutoff_sql` method instead.

##### `limit`

- Remove the `require 'pagy/extras/limit'` from the initializer.
- You should pass the `:requestable_limit` variable - set to the max limit requestable by the client - to the paginator method
  when you want to trigger the feature.

##### `metadata`

- Remove the `require 'pagy/extras/metadata'` from the initializer.
- Rename any existing `:scaffold_url` to `url_template`
- Remove any existing `Pagy::DEFAULT[:metadata]` variable and pass it to the paginator method

##### `overflow`

- Remove the `require 'pagy/extras/overflow'` from the initializer.
- You should pass the `:overflow: ...` variable to the paginator method when you want to trigger the feature.

#### `standlone`

- Remove the `require 'pagy/extras/standalone'` from the initializer.
- Replace the `:url` variable with `:request`, and its content with `{ url_prefix: 'the-previous-value-of-url' }`. You can also
  optionally add your `query_params` hash. For example `{ query_params: { param1: 'abc', param2: 'def' }` for complete control
  over the generated url.

##### `trim` (discontinued)

- It was mostly useless and half backed, causing a lot of complications in the ruby and javascript code.
- Use a proper way to address your requirement, like using URL rewriting at the HTTP server level.

##### `gearbox`

- Remove the `:gearbox_extra` variable from your code
- You should pass the `gearbox_limit: [...]` variable to the paginator method when you want to trigger the feature.

##### `i18n`, `size`

- No change required.

#### Possibly Breaking Overridings

- The internal Pagy protected methods have been renamed and refactored. If you use custom Pagy classes, you may need to search
  into the code.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
