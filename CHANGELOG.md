# CHANGELOG

## Version 5.0.0

### Breaking changes

Pagy 5.0.0 removes the support for a few deprecation still supported in pagy 4.

#### Suggestions for resolving unsupported deprecations

- upgrade to the latest pagy 4
- run your tests or app
- check the log for any deprecations message starting with '[PAGY WARNING]'
- update your code as indicated by the messages
- ensure that the log is free from warnings

Here is a list of the deprecations that are not supported anymore:

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

#### Consistency renaming

A few elements have been renamed: you code may or may not contain them. Just search and replace the following:

- `:enable_items_extra` rename to `items_extra`
- `:enable_trim_extra` rename to `trim_extra`
- `Pagy::Helpers` rename to `Pagy::UrlHelpers`
- `pagy_get_params` rename to `pagy_massage_params`

#### Items accessor

The items accessor does not adjust for the actual items in the last page anymore. This should not affect normal usage, so you can ignore this change unless you build something on that assumption.

If your code is relying on the actual number of items **in** the page, then just replace `@pagy.items` with `@pagy.in`.

FYI: The `@pagy.items` is now always equal to `@pagy.vars[:items]` (i.e. the requested items), while the `@pagy.in` returns the actual items in the page.
