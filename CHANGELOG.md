---
icon: versions-24
---

# CHANGELOG

## Release Policy

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/), and introduces BREAKING CHANGES only for MAYOR versions.

We release any new version (MAJOR, MINOR, PATCH) as soon as it is ready for release, regardless of any time constraint, 
frequency or duration.

We rarely deprecate elements (releasing a new MAYOR version is just simpler and more efficient). However, when we do, you 
can expect the old functionality to be supported ONLY during the next releases belonging to the same MAYOR version.

## Recommended Version Constraint

Given a version number `MAJOR.MINOR.PATCH` (e.g. `9.3.2`):

The `gem 'pagy', '~> 9.3'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to 
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAYOR version indicated in the Gemfile ONLY when you are ready to handle the BREAKING CHANGES

## Breaking Changes

If you upgrade from version `< 9.0.0` see the following:

- [Breaking changes in version 9.0.0](#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY.md#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY.md#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

- `:after_latest` keyset variable: use `:filter_newest`
<hr>

## Version 9.3.2

- Improve gapped series computation by a few milliseconds

## Version 9.3.1

- Added qualified column names to the keyset query

## Version 9.3.0

- Remove the :typecast_latest variable
- Add the :jsonify_keyset_attributes variable to override the encoding (#749)

## Version 9.2.2

- Replace inline templates with template block in sinatra apps
- Replace the rails calendar app with a sinatra app
- Add PagyApps::INDEX

## Version 9.2.1

- Improve bin/pagy to dynamically find apps and descriptions
- Apps refactoring:
  - Update rails to 8.0
  - Replace rails AR keyset apps with sinatra apps
  - Improve consistency

## Version 9.2.0

- Simplify the keyset API:
  - Deprecate the :after_latest variable in favour of :filter_newest
  - Add the keyset argument to the :filter_newest lambda
  - Rename protected after_latest_query > filter_newest_query

## Version 9.1.1

- Simplify calendar code

## Version 9.1.0

- Add Dzongkha (dz locale) (#741)

## Version 9.0.9

- Set freeze flag to false (#737)
- Fix: Prefix DEFAULT with Pagy:: (#736)

## Version 9.0.8

- Keep offset and limit variables untouched by the overflow extra in :empty_page mode (closes #733)

## Version 9.0.7

- Absolutize generic define? to fix module resolution

## Version 9.0.6

- Fix docs (closes #732)
- Replace pluck with pick

## Version 9.0.5

- Fix for missing variables passed to pagy_anchor from pagy_nav (closes #728)

## Version 9.0.4

- Fix groupdate timezone error on certain machines/config
- Fix gem containing tmp files

## Version 9.0.3

- Remove legacy and unused javascript files
- Improve pagy_get_page with force_integer option
- Fix jsonapi with keyset
- Complete the internal refactoring of version 9:
  - Remove the pagy*_get_vars methods now useless
  - Use to_i on the page variable for the search extras

## Version 9.0.2

- Rename and document the link header to pagy_link_header
- Add first and next url helpers to the keyset extra; add the keyset section to config/pagy.rb
- Fix nil page in keyset URL not overriding the params page
- Extracted shared method

## Version 9.0.1

- Fix countless executing the count query
- Rename row_comparison > tuple_comparison; ignore mixed orders

## Version 9.0.0

### Breaking Changes
    
#### Dropped support for deprecated stuff

- The `foundation`, `materialize`, `semantic` and `uikit` CSS extras have been removed:
  (See the [reasons](https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328))
- **Javascript renamed files**
  - `pagy.js`: use `pagy.min.js`
  - `pagy-module.js`: use `pagy.mjs`
  - `pagy-dev.js`: use the `pagy.min.js`with the `pagy.min.js.map`
  - `pagy-module.d.ts`: use `pagy.d.ts`
- The Array type for the `:size` (e.g. `size: [1, 4, 4, 1]`) that generates the classic bar is not supported anymore: use the 
  `:size` set to an integer with the `ends: true` variable (which are the default since 8.4.6). If a legacy bar remains REALLY 
  a requirement, add `require 'pagy/extras/size` to your `pagy.rb` initalizer. (See the 
  [size extra](https://ddnexus.github.io/pagy/docs/extras/size))
  
#### Simple renaming

We used `items` for too many things that confused even maintainers. The "items" are now referencing only the records/elements 
fetched from a collection (plural entity), so they are kept as before (e.g. `pagy_*get_items` methods).
The "number of items" (singular entity), are now unmistakably referenced as the `limit` everywhere (code, API, files, extras, 
docs, etc.). The logic didn't change so you have just to globally search 'items' and replace with `limit` and you should be 
done... or use the detailed table below:

| Type              | Search                   | Replace                      |
|-------------------|--------------------------|------------------------------|
| Pagy Variable     | `:items`                 | `:limit`                     |
| Extra Path        | `pagy/extras/items`      | `pagy/extras/limit`          |
| Extra Variable    | `:items_param`           | `:limit_param`               |
| Default URL param | `items`                  | `limit`                      |
| Extra Variable    | `:items_extra`           | `:limit_extra`               |
| Extra Variable    | `:max_items`             | `:limit_max`  (now inverted) |
| Extra Method      | `pagy_items_selector_js` | `pagy_limit_selector_js`     |
| Extra Variable    | `:headers[:items]`       | `:headers[limit]`            |

#### Code changes

- The `DEFAULT[:anchor_string]` was useless and has been dropped.
- The `:anchor_string`and the `:fragment` are not instance variables anymore, but keyword arguments for all the helpers, 
  because it is frontend code (see the [discussion](https://github.com/ddnexus/pagy/discussions/719)). Instead of passing them to the `pagy*` method in the controller, pass it to any `pagy_*nav` method in the view.
- A general internal revamp has changed the positional argument for the Pagy::* objects and constructors methods to keyword 
  arguments. If you get a `wrong number of arguments (given 1, expected 0) (ArgumentError)`, just use a double splat `**`.

#### Possibly breaking overrides

- The internal Pagy protected methods have been renamed and refactored. If you use custom Pagy 
  classes, you may need to search into the code.

## Changes

- Improve Keyset::Sequel and docs
- BREAKING: Rename :max_limit > :limit_max
- BREAKING: Rename variable, param, accessor, extra and helper "items" to "limit"
- Add playground keyset_ar.ru and keyset_s.ru apps and integration with the rest of the gems
- Add keyset pagination base files 
  - Pagy::Keyset API
  - ActiveRecord and Sequel adapters
- BREAKING: Transform the vars positional hash argument in keyword arguments (double splat); internal renaming of setup/assign methods
- Refactor pagy_get_vars in various backend extras
- BREAKING: Refactor the fragment url
- BREAKING: Refactor the anchor_string system
- BREAKING: Drop the support for 8+ deprecations

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
