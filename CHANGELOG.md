# CHANGELOG

## Breaking Changes

If you upgrade from version `< 5.0.0` see the following:

- [Breaking changes in version 5.0.0](#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

Still supported in version `5.x` but not supported from `6.0` on:

- `pagy_massage_params` method: use the `:params` variable set to a lambda `Proc` that does the same (but per instance). See [How to customize the params](https://ddnexus.github.io/pagy/how-to#customize-the-params).

<hr>

## Version 5.6.8

- Reorganized TypeScript/JavaScript with npm workspaces and better script naming
- Fix typo in gemspec
- Better typescript configuration with source maps and declrations

## Version 5.6.7

- GitHub Actions: added quotes to version ruby 3.0
- Added typescript + babel environment for better pagy.js
- Updated e2e environment
- Updated gemfiles
- Fix for support doc snippets and other typos
- Minor update of gemfiles and docs
- Added more gemspec metadata entries (closes #351)

## Version 5.6.6

- Docs improvements
- Added **_ to series and sequels
- Updated rematch and gemfiles
- Updated release-gem.yml workflow

## Version 5.6.5

- Improved a few code comments; added post link in README
- Full name for translate, aliased as t
- Added check for no calendar units in pagy_calendar configuration
- Updated gemfiles
- Small docs layout adjustment

## Version 5.6.4

- Updated RM run configurations
- Fix for missing innerHTML reset, unintentionally committed during a cleanup (closes #350)
- Updated gemfiles, docs and comments

## Version 5.6.3

- Improved readability and efficiency of calendar files
- Fix for English spelling in local variable name

## Version 5.6.2

- Updated pagy.manifest for Tamil locale
- Add Tamil (ta) translation (#349)
- Internal changes in calendar files:
  - Simpler calculations for month mixin
  - Normalized naming of non-api methods
  - Better comments
- Pagy::I18n: small performance improvement
- Docs reorganization
- Update paths_ignore for skip CI and docs

## Version 5.6.1

- Updated cypress and bundler
- Improved efficiency of unit labelling and support for custom calendar unit sub formats
- Added missing initializer default for calendar quarter and missing doc for custom units

## Version 5.6.0

- Updated gemfiles
- Updated docs
- Added calendar quarter tests
- Internal calendar refactoring to allow custom units; added quarter unit

## Version 5.5.1

- Docs updates
- upgrade bootstrap template navs: call pagy_link_proc with link_extra key (#348)
- Renamed internal #time_for -> #start_for
- Docs fixes and improvements

## Version 5.5.0

- Updated cypress and related packages
- **Calendar API: FINAL breaking changes** (stable from now on):
  - Refactoring of calendar classes and variables:
  - Moved calendar defaults from `Pagy::DEFAULT` to class-specific `Pagy::Calendar::*::DEFAULT`
  - Renamed variables:
    - `:minmax` -> `:period`
    - `:time_order` -> `:order`
    - `:week_offset` -> `:offset`
    - `:*_format` -> `:format`
  - Returning local time instead of UTC time for the utc accessors, now renamed:
    - `#utc_from` -> `#from` (use `from.utc` if you need it)
    - `#utc_to` -> `#to` (use `to.utc` if you need it)
  - Inverted the logic for the `:skip` key in the `#pagy_calendar` conf, now renamed:
    - `:skip` -> `:active`
  - Renamed methods:
    - `#pagy_calendar_minmax` -> `#pagy_calendar_period`
    - `#pagy_calendar_filtered` -> `#pagy_calendar_filter`
  - Added alternative way to delegate the localization to i18n without the i18n extra
  - Updated `pagy_calendar_app.ru`
  - Fix for wrong reordering in `:desc` order
  - Documentation fixes and improvements
  - Removed the warning for the API changes: the API is stable after these changes

## Version 5.4.0

- **Calendar API breaking changes** for refactoring of `Pagy::Calendar` and calendar extra:
  - Added complete compatibility with all the backend extras
  - Simpler usage with automatic handling of pagy objects
  - Less variables and simpler requirements for the methods to implement
- Updated gemfiles
- The localize method overridden by the i18n extra must receive a format
- Series and sequels use keyword arguments and pagy_*nav methods accepts a size keyword argument
- Docs improvements
- Removed unnecessary empty section in calendar docs
- Fixes for typos and misalignment

## Version 5.3.1

- Added screenshot to the calendar extra (closes #346)
- Added bump.sh script to bump the version in multiple files; check for consistency and optionally commit the changes
- Minor fixes
- Changelog improvements
- Reversed CHANGELOG (closes #345)
- Calendar I18n small internal renaming and docs improvements

## Version 5.3.0

- Implemented localization of time labels through the i18n extra delegation
- Renamed internal module and files of SharedExtra to FrontendHelpers
- Added support for `*nav_js` to Calendar
- Simplified page labelling, moved into the pagy classes and removed frontend methods
- Deprecated `pagy_massage_params`: use the :params variable set to a Proc that does the same, but per instance
- Added apps README
- Completed overflow fix for pagy Countless

## Version 5.2.3

- Fix for overflow :empty_page in regular Pagy instances, not returning an empty page
- docs: add tutorial, simplify header (#343)
- Refactoring of rails_inline_input.rb (include and close #342)

## Version 5.2.2

- Fix for missing defined?(Calendar) checks; small simplification in headers extra
- Calendar docs improvements and fixes

## Version 5.2.1

- Reorganization of mock collection classes; enabled rubocop layout in tests
- Small refactoring of the overview extra
- A few improvements for the Calendar pagination; added the current_page_label method

## Version 5.2.0

- Small changes in code; updated gemfiles, tests and docs
- Implemented calendar extra to paginate a Time periods by unit (year, month, week or day)
- Added pagy_labeler frontend method overridable for changing the link text from a simple page number to any arbitrary string
- Enabled rubocop Style/Documentation cop
- Updated npm modules and gemfiles
- Docker better mounts
- Used gem-generic release-gem action

## Version 5.1.3

- Added single action standalone rails_inline_output.rb
- Small improvements in code and docs
- Fix for rails problem with internal params in pagy URL (closes #341)
- Documentation improvements
- A few details tag in the README should be opened by default

## Version 5.1.2

- Refactoring of pagy_url_for and relative test:
  - Fix for ignoring the items_extra variable
  - Replaced request.GET with request.params to enable POST pagination
  - Refactoring of Mock test classes for better handling of params

## Version 5.1.1

- This reverts commit 1d77e672d5b7813108b40c13ca93fdec045f4c03.
  Generating the URL by using the application params method breakes rails apps because it requires manual changes in the apps.

## Version 5.1.0

- Fix and refactoring of pagy_url_for and relative test:
  - Fix for ignoring the params not coming from the request
  - Fix for ignoring the items_extra variable
  - Refactoring of Mock test classes for better handling of params
- Improved code comments, formatting and docs fixes
- Countless extra: simplified code, internal renaming of locals and docs update

## Version 5.0.1

- Updated docs and issue templates
- Added cypress-dark theme to e2e test
- Refactoring of coverage to include 100% of line and condition branches covered
- Simplification of metadata extra
- Refactoring of exceptions
- Added CHANGELOG_LEGACY

## Version 5.0.0

### Breaking changes - 1. Code update

Pagy 4 dropped the compatibility for old ruby versions `>2.5` and started to refactor the code using more modern syntax and paradigms and better performance. It deprecated the legacy ones, printing deprecation warnings and upgrading instruction in the log, but still supporting its legacy API. Pagy 5.0.0 cleans up and removes all that transitional support code.

The changes for upgrading your app cannot be fixed with simple search and replace, but fear not! Fixing them should just take a few minutes with the following steps:

- Upgrade to the latest version of pagy 4
- Run your tests or app
- Check the log for any deprecations message starting with '[PAGY WARNING]'
- Update your code as indicated by the messages
- Ensure that the log is now free from warnings
- Upgrade to pagy 5

FYI: Here is the list of the deprecations that are not supported anymore:

#### Removed support for deprecated variables

- `Pagy::VARS[:anchor]` is now `Pagy::DEFAULT[:fragment]`

#### Removed support for deprecated arguments order

- The argument order in `pagy_url_for(page, pagy)` is now inverted: `pagy_url_for(pagy, page)`

#### Removed support for deprecated positional arguments

The following optional positional arguments are passed with keywords arguments in all the pagy helpers:

- The `id` html attribute string with the `pagy_id` keyword
- The `url|absolute` flag with the `absolute` keyword
- The `item_name` string with the `item_name` keyword
- The `extra|link_extra` string with the `link_extra` keyword
- The `text` string with the `text` keyword

### Breaking changes - 2. Simple search and replace

There are a few renaming that have not been deprecated in previous versions because they are extremely easy to fix with simple search and replace (while implementing deprecations would have been detrimental to performance and complex for no reason)

#### Consistency renaming

A few elements have been renamed: you code may or may not contain them. Just search and replace the following strings:

- Rename `Pagy::VARS` to `Pagy::DEFAULT`
- Rename `enable_items_extra` to `items_extra`
- Rename `enable_trim_extra` to `trim_extra`
- Rename `Pagy::Helpers` to `Pagy::UrlHelpers`
- Rename `pagy_get_params` to `pagy_massage_params`

#### Items accessor

The items accessor does not adjust for the actual items in the last page anymore. This should not affect normal usage, so you can ignore this change unless you build something on that assumption.

If your code is relying on the actual number of items **in** the page, then just replace `@pagy.items` with `@pagy.in` wherever you meant that.

FYI: The `@pagy.items` is now always equal to `@pagy.vars[:items]` (i.e. the requested items), while the `@pagy.in` returns the actual items in the page (which could be less than the `items` when the page is the last page)

### Changes

- Removed support for deprecations
- Refactoring of Pagy and Pagy::Countless classes, I18n, and url helpers
- Refactoring of the docker environment, addition of ready to use VSCode setup
- Changed general module structure (use of prepend instead of re-opening modules)
- Added gearbox extra for geared pagination
- Added configuration files for a full working VSCode devcontainer environment
- Added Run Configurations for RubyMine
- Improved the usage of e2e tests
- Updated doc, gemfiles and github workflow
- Other minor fixes and improvements in code and doc
