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

#### The extras are all gone

They have been converted to autoloaded mixins, or integrated in the core code at zero-cost and a few are discontinued.

You can now use the methods that you need, and they will just work without the need of any explicit `require`.

The only extras that are left _(for different compelling reasons)_ are: `gearbox`, `i18n` and `size`. They must be required in the
initializer as usual.

#### The Pagy::Countless remembers the last page

When you jump back a few pages in the pagination nav, it remembers the last page count, so you can jump forward as well now.

#### Cleaner URLs

- No more empty params or extra '?' in the URL string; URL templates are safer for string manipulation.
- The `pagy_page_url` (legacy `pagy_url_for`) can be used also without a request (incorporating the legacy `standalone` extra)

#### Javascript refactoring

Updated the support for the pagy helpers and keynav pagination. Added the plain `pagy.js` and relative source map.

### Breaking Changes

#### Simple renaming (without logic changes)

| Type        | Search           | Replace         | Notes                                                    |
|-------------|------------------|-----------------|----------------------------------------------------------|
| Constructor | `pagy(`          | `pagy_offset(`  | Consistent with the other old and new constructors       |
| Function    | `Pagy.root`      | `Pagy::ROOT`    | It's just a Pathname object                              |
| Variable    | `:page_param`    | `:page_sym`     | It was confusing                                         |
| Variable    | `:limit_param`   | `:limit_sym`    | It was confusing                                         |
| Method      | `pagy_url_for`   | `pagy_page_url` | The legacy naming was causing rails-related expectations |
| Method/args | `label_for(page` | `label(page: `  | The name has changed and `page` is a keywork argument    |

#### Direct instantiation of the pagy classes is not recommended

- Use the provided paginators for easier usage, maintenance and forward compatibility.
- Use the classes only if the documentation suggests you to do so, or if you really you know what you are doing.

#### The `Pagy::DEFAULT` is now frozen

- Remove all the `Pagy::DEFAULT` statements and pass their variables to the paginator constructors that you use.
- As an alternative to avoid repetitions, define your own default hash and pass it to the different paginator methods. See the new
  initializer for details.

#### Replace your `pagy.rb` config file

With no more `Pagy::DEFAULT` and no more extras to require, the statements in your old version are all obsolete but any existing
`Pagy::I18n` configuration, so it's better to start with the new version of the file, and copy over the `Pagy::I18n` (if you used
it).

#### Core changes

- If you used the `:params` variable set to a lambda, ensure that it modifies the passed `query_params` directly. The returned
  value is now ignored for a sligtly better performance.

#### Extras Changes

All the extras are gone: here is what to

##### `arel`, `array`, `boostrap`, `bulma`, `countless`, `pagy`

- Just use their features without further changes.

##### `calendar`

If you need the I18n localization, discard your old config, and uncomment/add this line to your initializer:
`Pagy::Offset::Calendar.localize_with_rails_i18n_gem(*your_locales)`

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- Replace any existing `Pagy.new_from_<extra-name>` with `pagy_<extra-name>`. _(Active and passive modes are now handled by the
  same paginator.)_
- Replace any existing `extend Pagy::Search` statement in your models with `extend Pagy::Offset::Search`.
- Remove any existing `:<extra-name>_pagy_search`
  variable from your code, and use the standard `pagy_search` method instead. _(the `pagy_search` name customization has been
  discontinued.)_
- Rename any existing `:<extra-name>_search` variable as `:search_method` and pass it to the paginator method.

##### `headers`

- Rename any existing `:scaffold_url` to `url_template`
- Pass any existing `:headers` variable to the paginator method

##### `jsonapi`

- Rename any existing `pagy_jsonapi_links` as `pagy_links`. Notice that the `nil` links are now removed as the `JSON:API`
  requires.
- You should pass the `:jsonapi` variable to the paginator method when you want to trigger the feature.

##### `keyset`

- Replace any existing `:jsonify_keyset_attributes` with `stringify_keyset_values`. The lambda receives the same
  `keyset_attributes` but it must return the array of attribute values `->(keyset_attributes) { ...; keyset_attributes.values }`.
- Remove any existing`:filter_newest`. Override the `after_cutoff_sql` method instead.

##### `limit`

- You should pass the `:requestable_limit` variable - set to the max limit requestable by the client - to the paginator method
  when you want to trigger the feature.

##### `metadata`

- Rename any existing `:scaffold_url` to `url_template`
- Pass any existing `:metadata` variable to the paginator method

##### `overflow`

- You should pass the `:overflow: ...` variable to the paginator method when you want to trigger the feature.

#### `standlone`

- Replace the `:url` variable with `:request` and its content with `{ url_prefix: 'the-previous-value-of-url' }`. You can also
  optionally add your `query_params` hash. For example:
  `request: { url_prefix: 'the-previous-value-of-url', query_params: { param1: 'abc', param2: 'def' }}` for complete control over
  the generated url.

##### `i18n` (discontinued)

- If you REALLY need it, uncomment/add this line to your initializer: `Pagy::Frontend.translate_with_the_slower_i18n_gem!`

##### `gearbox` (discontinued)

- Copy the file at `https://github.com/ddnexus/pagy/blob/master/legacy/gearbox.rb` in your app and require the copy in the
  initializer.
- Remove the `:gearbox_extra` variable from your code
- You should pass the `gearbox_limit: [...]` variable to the paginator method when you want to trigger the feature.
- The file will not be upgraded in the future, so you must maintain it. The test file is available at
  `https://github.com/ddnexus/pagy/blob/master/legacy/gearbox_test.rb`

##### `size` (discontinued)

- Copy the file at `https://github.com/ddnexus/pagy/blob/master/legacy/size.rb` in your app and require the copy in the
  initializer.
- The file will not be upgraded in the future, so you must maintain it. The test file is available at
  `https://github.com/ddnexus/pagy/blob/master/legacy/size_test.rb`

##### `trim` (discontinued)

- It was mostly useless and half backed, causing a lot of complications in the ruby and javascript code.
- Use a proper way to address your requirement, like using URL rewriting at the HTTP server level.

#### Possibly Breaking Overridings

- The internal Pagy protected methods have been renamed and refactored. If you use custom Pagy classes, you may need to search
  into the code.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
