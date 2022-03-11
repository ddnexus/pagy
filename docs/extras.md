---
title: Extras
icon: plus-circle-24
---

# Extras

Pagy comes with a growing number of optional extras, that add core, backend, frontend or special features to the regular core features.

| Extra                 | Description                                                                                                                                              | Links                                                                                                                                                        |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `arel`                | Better performance of grouped ActiveRecord collections                                                                                                   | [arel.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/arel.rb), [documentation](extras/arel.md)                                              |
| `array`               | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                                     | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](extras/array.md)                                           |
| `bootstrap`           | Add nav, nav_js and combo_nav_js helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)               | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](extras/bootstrap.md)                               |
| `bulma`               | Add nav, nav_js and combo_nav_js helpers for the Bulma [pagination component](https://bulma.io/documentation/components/pagination)                      | [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb), [documentation](extras/bulma.md)                                           |
| `calendar`            | Add pagination filtering by calendar time unit (year, quarter, month, week, day)                                                                         | [calendar.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb), [documentation](extras/calendar.md)                                 |
| `countless`           | Paginate without any count, saving one query per rendering                                                                                               | [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb), [documentation](extras/countless.md)                               |
| `elasticsearch_rails` | Paginate `elasticsearch_rails` gem results efficiently                                                                                                   | [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb), [documentation](extras/elasticsearch_rails.md) |
| `foundation`          | Add nav, nav_js and combo_nav_js helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)               | [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb), [documentation](extras/foundation.md)                            |
| `gearbox`             | Automatically change the number of items per page depending on the page number                                                                           | [gearbox.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/gearbox.rb), [documentation](extras/gearbox.md)                                     |
| `headers`             | Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API pagination                        | [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb), [documentation](extras/headers.md)                                     |
| `i18n`                | Use the `I18n` gem instead of the pagy implementation                                                                                                    | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](extras/i18n.md)                                              |
| `items`               | Allow the client to request a custom number of items per page with a ready to use selector UI                                                            | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](extras/items.md)                                           |
| `materialize`         | Add nav, nav_js and combo_nav_js helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)                      | [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb), [documentation](extras/materialize.md)                         |
| `meilisearch`         | Paginate `Meilisearch` results efficiently                                                                                                               | [meilisearch.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/meilisearch.rb), [documentation](extras/meilisearch.md)                         |
| `metadata`            | Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.                                                                    | [metadata.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/metadata.rb), [documentation](extras/metadata.md)                                  |
| `navs`                | Add nav_js and combo_nav_js javascript unstyled helpers                                                                                                  | [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb), [documentation](extras/navs.md)                                              |
| `overflow`            | Allow for easy handling of overflowing pages                                                                                                             | [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb), [documentation](extras/overflow.md)                                  |
| `searchkick`          | Paginate `Searchkick::Results` objects efficiently                                                                                                       | [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb), [documentation](extras/searchkick.md)                            |
| `semantic`            | Add nav, nav_js and combo_nav_js helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)                   | [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb), [documentation](extras/semantic.md)                                  |
| `standalone`          | Use pagy without any request object, nor Rack environment/gem, nor any defined `params` method, even in the irb/rails console without any app or config. | [standalone.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/standalone.rb), [documentation](extras/standalone.md)                            |
| `support`             | Extra support for features like: incremental, infinite, auto-scroll pagination                                                                           | [support.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/support.rb), [documentation](extras/support.md)                                     |
| `trim`                | Remove the `page=1` param from links                                                                                                                     | [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb), [documentation](extras/trim.md)                                              |
| `tailwind`            | Extra styles for [Tailwind CSS](https://tailwindcss.com)                                                                                                 | [documentation](extras/tailwind.md)                                                                                                                          |
| `uikit`               | Add nav, nav_js and combo_nav_js helpers for the UIkit [pagination component](https://getuikit.com/docs/pagination)                                      | [uikit.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/uikit.rb), [documentation](extras/uikit.md)                                           |

## Synopsis

Extras are not loaded by default, so you should require them explicitly in your `pagy.rb` initializer (see [Quick Start](quick-start.md#configure-pagy):

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/...'
```

## Description

Extras add features by defining their own `*Extra` module that get prepended to other pagy classes or modules. This neatly separates the core code from the optional extras, leaving a trace in the `ancestors` array to improve introspection and debugging info.

**Notice**: In previous Pagy versions extras were re-opening the `Pagy` class and modules. That is good as long as you have just a few extras... which is not the case anymore.

## Methods

A few extras require the [pagy/extras/shared](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/shared.rb) file. It defines only a few methods used internally, so you don't actually need to use them directly.

**Notice**: All the other added methods are documented in the respective extras doc.

## Javascript Helpers

A few frontend extras add helpers that use javascript, and they are clearly recognizable by the `js` suffix:

- `pagy*_nav_js`
- `pagy*_combo_nav_js`
- `pagy_items_selector_js`

See [Javascript](api/javascript.md)
