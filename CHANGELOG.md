# CHANGELOG

## Version 5.0.0

### Breaking changes - Simple search and replace

There are a few renaming that have not been deprecated in previous versions because they are extremely easy to fix with simple search and replace (while implementing deprecations would have been detrimental to performance and complex for no reason)

#### Consistency renaming

A few elements have been renamed: you code may or may not contain them. Just search and replace the following strings:

- `Pagy::VARS` rename to `Pagy::DEFAULT`
- `enable_items_extra` rename to `items_extra`
- `enable_trim_extra` rename to `trim_extra`
- `Pagy::Helpers` rename to `Pagy::UrlHelpers`
- `pagy_get_params` rename to `pagy_massage_params`

#### Items accessor

The items accessor does not adjust for the actual items in the last page anymore. This should not affect normal usage, so you can ignore this change unless you build something on that assumption.

If your code is relying on the actual number of items **in** the page, then just replace `@pagy.items` with `@pagy.in` wherever you meant that.

FYI: The `@pagy.items` is now always equal to `@pagy.vars[:items]` (i.e. the requested items), while the `@pagy.in` returns the actual items in the page (which could be less than the `items` when the page is the last page)

### Breaking changes - Code update

Pagy 4 dropped the compatibility for old ruby versions `>2.5` and started to refactor the code using more modern syntax and paradigms and better performance. It deprecated the legacy ones, printing deprecation warnings and upgrading instruction in the log, but still supporting its legacy API. Pagy 5.0.0 cleans up and removes all that transitional support code.

The changes for upgrading your app cannot be fixed with simple search and replace, but fear not! Fixing them should just take a few minutes with the following steps:

- upgrade to the latest version of pagy 4
- run your tests or app
- check the log for any deprecations message starting with '[PAGY WARNING]'
- update your code as indicated by the messages
- ensure that the log is now free from warnings
- upgrade to pagy 5

FYI: Here is the list of the deprecations that are not supported anymore:

#### Removed support for deprecated variables

- `Pagy::VARS[:anchor]` is now `Pagy::VARS[:fragment]`

#### Removed support for deprecated arguments order

- The argument order `pagy_url_for(page, pagy)` is now inverted: `pagy_url_for(pagy, page)`

#### Removed support for deprecated positional arguments

The following optional positional arguments are passed with keywords arguments in all the pagy helpers:

- The `id` html attribute string with the `pagy_id` keyword
- The `url/absolute` flag with the `absolute` keyword
- The `item_name` string with the `item_name` keyword
- The `extra/link_extra` string with the `link_extra` keyword
- The `text` string with the `text` keyword

### Changes

- Removed support for deprecations
- Refactoring of Pagy and Pagy::Countless classes, I18n, and url helpers
- Refactoring of the docker environment, addition of ready to use VSCode setup
- Changed general module structure (use of prepend instead of re-opening modules)
- Added gearbox extra for geared pagination
- Added configuration files for a full working VSCode devcontainer environment
- Updated doc, gemfiles and github workflow
- Other minor fixes and improvements in code and doc
