---
title: Extras
---
# Extras

Pagy comes with a few optional extensions/extras:

| Extra        | Description                                                                                            | Links                                                                                                                                                                                                                                               |
| ------------ | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `array`      | Paginate arrays efficiently avoiding expensive array-wrapping and wihout overriding                    | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](extras/array.md)                                                                                                                                  |
| `bootstrap`  | Nav helper and templates for Bootstrap pagination                                                      | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](extras/bootstrap.md)                                                                                                                      |
| `compact`    | An alternative UI that combines the pagination  with the nav info in a single compact element          | [compact.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/compact.rb), [pagy-compact.js](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/javascripts/pagy-compact.js), [documentation](extras/compact.md)                |
| `i18n`       | Use the `I18n` gem instead of the pagy implementation                                                  | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](extras/i18n.md)                                                                                                                                     |
| `items`      | Allow the client to request a custom number of items per page with a ready to use UI selector          | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](extras/items.md)                                                                                                                                  |
| `responsive` | On resize, the number of page links will adapt in real-time to the available window or container width | [responsive.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/responsive.rb), [pagy-responsive.js](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/javascripts/pagy-responsive.js), [documentation](extras/responsive.md) |

## Synopsys

Extras are not loaded by default, so you should require them explicitly in your initializer _(see [Configuration](how-to.md#global-configuration))_:

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/...'
```

## Description

Extras don't define any new module or class, they just re-open the `Pagy` class and modules, adding the extra methods as they were part of the loaded `pagy` gem. This neatly separates the core code from the optional extras, still keeping its usage as simple as it were part of the core gem.

## Methods

All the added methods are documented in the respective extras.
