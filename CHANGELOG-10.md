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

This version represents a global overhaul, restructuring the foundation to resolve the accumulated inconsistencies of previous,
incrementally-adapted releases. We made a lot of changes to make things easier, simpler and more maintenable.

There is a brand-new documentation with more concise and practical guides, and better organized in-depth separate sections.

We also embed the new `Pagy AI`, ready to answer your questions (faster and better than us).

### Keynav Pagination Addition

We just invented the `keynav` pagination: the pagy-exclusive technique to use `keyset` pagination with all the Frontend helpers.
The best technique for performance AND functionality! Check it out.

### Improvements

#### Automatic loading of just the code that you actually use

Every class, module and helper is automatically loaded only if you actually use it, without the need of any explicit `require`.
The legacy version was requiring more code by default; this one is autoloading only the specific methods.

#### The extras are all gone

They have been converted to autoloaded mixins, or integrated in the core code at zero-cost, or discontinued (when really useless).

You can now use the methods that you need, and they will just work without the need of any explicit `require`.

### The configuration is minimal and non-technical

Take a look at the configuration file: all the extra `requires` and the `Pagy::DEFAULT` configurations are gone. The only 3
optional configuration left, are simple one-liner Pagy function calls.

#### Better file and namespace system organization and coding style

The class hierarchy, the mixin files, and the test file structure have been deeply reorganized. The code is cleaner, more concise
and more readable, adding fewer modules to the `ancestors` array of your app. Also, abbreviated naming is gone consistently
everywhere.

#### The Pagy::Countless remembers the last page

When you jump back a few pages in the pagination nav, it remembers the last page count, so you can jump forward as well now.

#### Cleaner URLs

- No more empty params or extra '?' in the URL string; URL templates are safer for string manipulation.
- The `pagy_page_url` (legacy `pagy_url_for`) can be used also without a request (incorporating the legacy `standalone` extra)

#### Javascript refactoring

Updated the support for all the pagy helpers and `keynav` pagination. Added the plain `pagy.js` and relative source map.

Added `Pagy::Javascript.install` function to avoid messing up with complicated javascript cofigurations.

#### I18n refactoring

No setup required. The locales and their pluralization are autoloaded when you app use them.

The code is simpler and lighter, you can also override the lookup of dictionary files with
`Pagy::I18n::PATHNAMES.unshift(Pathname.new('my/customized/dictionaries'))`.

### Breaking Changes

#### Simple search and replace renaming (without logic changes)

Your app likely uses just a little fraction of the renamed things in the list below, but we wrote them all for completeness:

| Type        | Search           | Replace                     | Notes                                                                     |
|-------------|------------------|-----------------------------|---------------------------------------------------------------------------|
| Constructor | `pagy(`          | `pagy_offset(`              | Consistent with the other old and new constructors                        |
| Function    | `Pagy.root`      | `Pagy::ROOT`                | Stop calling a method just to get a constant Pathname                     |
| Accessor    | `pagy.vars`      | `pagy.options`              | They are actually options that don't change during execution              |
| Exception   | `VariableError`  | `OptionError`               | Error for the passed options. VariableError was not accurate              |
| Accessor    | `err.variable`   | `err.option`                | Accessor for OptionError instance variable, consistent with the class     |
| Option      | `size: 7`        | `length: 7`                 | Series length: more accurate, and avoid confusion with other `size`s      |
| Option      | `ends: false`    | `compact: true`             | Compact-gapless series: the boolean inverse of `ends`                     |
| Option      | `:page_param`    | `:page_sym`                 | The '_param' could be confused with the actual param value                |
| Option      | `:limit_param`   | `:limit_sym`                | The '_param' could be confused with the actual param value                |
| Method      | `pagy_anchor`    | `pagy_anchor_lambda` | It creates a lambda that creates an anchor tag, not the anchor tag itself |
| Method      | `pagy_url_for`   | `pagy_page_url`             | The legacy name was causing rails-related expectations                    |
| Method/args | `label_for(page` | `label(page: page`          | Simpler name: `page` is now a keywork argument                            |
| Method/args | `label(page`     | `label(page: page`          | Same name: `page` is now a keywork argument                               |
| Naming      | `*prev*`         | `*previous*`                | Unabbreviated word everywhere (option, accessor, methods, CSS class)      |
| Method      | `pagy_prev_a`    | `pagy_previous_anchor`      | Unabbreviated words                                                       |
| Method      | `pagy_next_a`    | `pagy_next_anchor`          | Unabbreviated words                                                       |

#### Replace your `pagy.rb` config file

With no more `Pagy::DEFAULT` and no more extras to `require`, all the statements in your old version are obsolete, so it's better
to start with the new version of the file.

#### The `Pagy::DEFAULT` is now frozen

- The `Pagy::DEFAULT` is now an internal hash and it's frozen. If you set any option with it, you should pass them to the
  paginator methods.
- As an alternative to avoid repetitions, define your own PAGY_OPTIONS hash and pass it to the different paginator
  methods/helpers. See the new initializer for details.

#### Core changes

- If you used the `:params` variable set to a lambda, ensure that it modifies the passed `query_params` directly. The returned
  value is now ignored for a sligtly better performance.
- The `:outset` and `:cycle` variables have been removed. They were seldom used, mostly useless, and implementing them in your
  code is trivial.
- You can pass the `:length` and `countless` options (legacy `:size` and `ends`), preferably to the `*_nav`, `_nav_js` helpers,
  but it's also possible to pass them to the paginator.

#### Extras Changes

All the extras are gone. Here is what to do in order to accomodate the changes:

##### `arel`, `array`, `boostrap`, `bulma`, `countless`, `pagy`

- Just use their features without further changes.

##### `calendar`

- Discard your old localization config (if any), and uncomment this line in the `pagy.rb` initializer:
  `Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)`.
  - In non-rails apps, calendar localization requires to add `rails-i18n` to your Gemfile.
- Replace the existing `Pagy::Calendar::OutOfRangeError` with `Pagy::RangeError`

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- Replace any existing `Pagy.new_from_<extra-name>` with `pagy_<extra-name>`. _(Active and passive modes are now handled by the
  same paginator.)_
- Remove any existing `:<extra-name>_pagy_search` variable from your code, and use the standard `pagy_search` method instead. _(
  the `pagy_search` name customization has been discontinued.)_
- Rename any existing `:<extra-name>_search` variable as `:search_method` and pass it to the paginator method.

##### `headers`

- Rename any existing `:headers` variable to `:header_names` (it's a hash mapping headers to names)
- You can pass your `:header_names` to the paginator method or to the `pagy_headers` helper method (which has priority).

##### `jsonapi`

- Rename any existing `pagy_jsonapi_links` as `pagy_links`. Notice that the `nil` links are now removed as the `JSON:API`
  requires.
- You should pass the `{ jsonapi: true }` variable to the paginator method when you want to trigger the feature.

##### `keyset`

- Replace any existing `:jsonify_keyset_attributes` with `stringify_keyset_values`. The lambda receives the same
  `keyset_attributes` argument, but it must return the array of attribute values
  `->(keyset_attributes) { ...; keyset_attributes.values }`.
- Remove any existing`:filter_newest`. Override the `compose_predicate` method instead.

##### `limit`

- You should pass the `{ requestable_limit: your_max_limit }` variable - set to the max limit requestable by the client - to the
  paginator method when you want to trigger the feature.

##### `metadata`

- Rename `pagy_metadata` to `pagy_data` (indeed it's just pagy data)
- Rename any existing `:scaffold_url` to `url_template`
- Rename any existing `:metadata` variable to `:data_keys`
- You can pass your `:data_keys` array to the paginator method or to the `pagy_data` helper method (which has priority).

##### `overflow`

- No error to rescue anymore: error only on demand. Now it works like it was requiring the extra and using its default.
- Here is how to get the old behavior with the new implementation:
  - If you used no extra (i.e. pagy raised errors): set `{ raise_range_error: true }`
  - If you used `{ overflow: :empty_page }` or just required the overflow extra: just remove it (it's the current default)
  - If you used `{ overflow: :last_page }`: set `{ raise_range_error: true }` and use `rescue Pagy::RangeError => e` in your
    method to reload `pagy.last`, redirecting to `pagy_page_url(pagy, pagy.last)`... but read the note below:
- Notice that the nav bar of an out-of-range request is served as it would be being last page, just with empty records/results,
  and the previous page button points to the last page, so you should consider that if the users really want to see the last page
  results (which they have already seen), they can just click on the last page link. Is the extra complication worth the minimal
  benefit (if any)?.
- You have also the `pagy.in_range?` method to check it (the opposite boolean of the legacy `pagy.overflow?`).

#### `standlone`

- Replace the `:url` variable with `:request` and its content with `{ url_prefix: 'the-previous-value-of-url' }`. You can also
  optionally add your `query_params` hash. For example:
  `request: { url_prefix: 'the-previous-value-of-url', query_params: { param1: 'abc', param2: 'def' }}` for complete control over
  the generated url.

##### `i18n`

- If you REALLY need it, uncomment/add this line to your initializer: `Pagy::Frontend.translate_with_the_slower_i18n_gem!`

##### `gearbox` (discontinued feature)

- The feature require so much overwriting for so little difference that you better just remove it from your app and nobody will
  even notice.

##### `size` (discontinued feature)

- Pagination bars similar to WillPaginate and Kaminari are not good. If you still want it, you can adapt the legacy file from an
  old commit.

##### `trim` (discontinued feature)

- It was mostly useless and half backed, causing a lot of complications in the ruby and javascript code for no reszl benefit.
- Use a proper way to address your requirement, like using URL rewriting at the HTTP server level.

#### Direct instantiation of the pagy classes is not recommended

- Use the provided `paginators` for easier usage, maintenance and forward compatibility.
- Use the implementing classes only if the documentation explicitly suggests you to do so, or if you know what you are doing.

#### Possibly Breaking Overridings

- The internal Pagy protected methods have been renamed and refactored. If you use custom Pagy classes, you may need to search
  into the code.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
