# CHANGELOG

## Version 5.0.0

### Breaking changes

Pagy 5.0.0 removes the support for a few deprecation still supported in pagy 4.

#### Suggestions for resolving unsupported deprecations

- upgrade to the latest pagy 4
- run your tests or app
- check the log for any deprecations message starting with '[PAGY WARNING]'
- update your code as indicated
- ensure that the log is free from warnings

Here is a list of the deprecations that are not suppoted anymore:

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

A couple of variables used in extras have been renamed. You are affected by the change only if you explicitly used the specific extra AND its variable.
Sorry, there was no deprecation in version 4, however it's just a matter of search and replace.

- `:enable_items_extra` is now `items_extra`
- `:enable_trim_extra` is now `trim_extra`

#### Items accessor

This should not affect normal usage. The items accessor does not adjust for the actual items in the last page anymore. You can ignore this change unless you build something weird on that assumption: in that case, just use the new `in` accessor that behave exactly as the `items` of version 4.
