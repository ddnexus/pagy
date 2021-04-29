---
title: Extras
---
# Extras

Pagy comes with a few optional extensions/extras:

| Extra                 | Description                                                                                                                                              | Links                                                                                                                                                                                   |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `arel`                | Better performance of grouped ActiveRecord collections                                                                                                   | [arel.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/arel.rb), [documentation](http://ddnexus.github.io/pagy/extras/arel)                                              |
| `array`               | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                                     | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](http://ddnexus.github.io/pagy/extras/array)                                           |
| `bootstrap`           | Add nav, nav_js and combo_nav_js helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)               | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](http://ddnexus.github.io/pagy/extras/bootstrap)                               |
| `bulma`               | Add nav, nav_js and combo_nav_js helpers for the Bulma [pagination component](https://bulma.io/documentation/components/pagination)                      | [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb), [documentation](http://ddnexus.github.io/pagy/extras/bulma)                                           |
| `countless`           | Paginate without any count, saving one query per rendering                                                                                               | [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb), [documentation](http://ddnexus.github.io/pagy/extras/countless)                               |
| `elasticsearch_rails` | Paginate `elasticsearch_rails` gem results efficiently                                                                                                   | [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb), [documentation](http://ddnexus.github.io/pagy/extras/elasticsearch_rails) |
| `foundation`          | Add nav, nav_js and combo_nav_js helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)               | [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb), [documentation](http://ddnexus.github.io/pagy/extras/foundation)                            |
| `headers`             | Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API pagination                        | [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb), [documentation](http://ddnexus.github.io/pagy/extras/headers)                                     |
| `i18n`                | Use the `I18n` gem instead of the pagy implementation                                                                                                    | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](http://ddnexus.github.io/pagy/extras/i18n)                                              |
| `items`               | Allow the client to request a custom number of items per page with a ready to use selector UI                                                            | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](http://ddnexus.github.io/pagy/extras/items)                                           |
| `materialize`         | Add nav, nav_js and combo_nav_js helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)                      | [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb), [documentation](http://ddnexus.github.io/pagy/extras/materialize)                         |
| `metadata`            | Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.                                                                    | [metadata.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/metadata.rb), [documentation](http://ddnexus.github.io/pagy/extras/metadata)                                  |
| `navs`                | Add nav_js and combo_nav_js javascript unstyled helpers                                                                                                  | [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb), [documentation](http://ddnexus.github.io/pagy/extras/navs)                                              |
| `overflow`            | Allow for easy handling of overflowing pages                                                                                                             | [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb), [documentation](http://ddnexus.github.io/pagy/extras/overflow)                                  |
| `searchkick`          | Paginate `Searchkick::Results` objects efficiently                                                                                                       | [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb), [documentation](http://ddnexus.github.io/pagy/extras/searchkick)                            |
| `semantic`            | Add nav, nav_js and combo_nav_js helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)                   | [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb), [documentation](http://ddnexus.github.io/pagy/extras/semantic)                                  |
| `standalone`          | Use pagy without any request object, nor Rack environment/gem, nor any defined `params` method, even in the irb/rails console without any app or config. | [standalone.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/standalone.rb), [documentation](http://ddnexus.github.io/pagy/extras/standalone)                            |
| `support`             | Extra support for features like: incremental, infinite, auto-scroll pagination                                                                           | [support.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/support.rb), [documentation](http://ddnexus.github.io/pagy/extras/support)                                     |
| `trim`                | Remove the `page=1` param from links                                                                                                                     | [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb), [documentation](http://ddnexus.github.io/pagy/extras/trim)                                              |
| `tailwind`            | Extra styles for [Tailwind CSS](https://tailwindcss.com)                                                                                                 | [documentation](http://ddnexus.github.io/pagy/extras/tailwind)                                                                                                                          |
| `uikit`               | Add nav, nav_js and combo_nav_js helpers for the UIkit [pagination component](https://getuikit.com/docs/pagination)                                      | [uikit.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/uikit.rb), [documentation](http://ddnexus.github.io/pagy/extras/uikit)                                           |

## Synopsis

Extras are not loaded by default, so you should require them explicitly in your `pagy.rb` initializer _(see [Configuration](how-to.md#global-configuration))_:

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/...'
```

## Description

Extras don't define any new module or class, they just re-open the `Pagy` class and modules, adding the extra methods as they were part of the loaded `pagy` gem. This neatly separates the core code from the optional extras, still keeping its usage as simple as it were part of the core.

## Methods

A few extras require the [pagy/extras/shared](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/shared.rb) file. It defines only a few methods used internally, so you don't actually need to use them directly.

**Notice**: All the other added methods are documented in the respective extras doc.

## Javascript Helpers

A few helpers use javascript, and they are clearly recognizable by the `js` suffix:

- `pagy*_nav_js`
- `pagy*_combo_nav_js`
- `pagy_items_selector_js`

See [Javascript](api/javascript.md)
