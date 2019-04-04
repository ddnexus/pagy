---
title: Extras
---
# Extras

Pagy comes with a few optional extensions/extras:

| Extra                 | Description                                                                                                                               | Links                                                                                                                                                        |
|:----------------------|:------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `array`               | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                      | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](extras/array.md)                                           |
| `bootstrap`           | Add nav, responsive and compact helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination) | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](extras/bootstrap.md)                               |
| `bulma`               | Add nav, responsive and compact helpers for the Bulma [pagination component](https://bulma.io/documentation/components/pagination)        | [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb), [documentation](extras/bulma.md)                                           |
| `countless`           | Paginate without any count, saving one query per rendering                                                                                | [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb), [documentation](extras/countless.md)                               |
| `elasticsearch_rails` | Paginate `elasticsearch_rails` gem results efficiently                                                                                    | [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb), [documentation](extras/elasticsearch_rails.md) |
| `foundation`          | Add nav, responsive and compact helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html) | [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb), [documentation](extras/foundation.md)                            |
| `headers`             | Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API pagination         | [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb), [documentation](extras/headers.md)                                     |
| `i18n`                | Use the `I18n` gem instead of the pagy implementation                                                                                     | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](extras/i18n.md)                                              |
| `items`               | Allow the client to request a custom number of items per page with a ready to use selector UI                                             | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](extras/items.md)                                           |
| `materialize`         | Add nav, responsive and compact helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)        | [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb), [documentation](extras/materialize.md)                         |
| `overflow`            | Allow for easy handling of overflowing pages                                                                                              | [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb), [documentation](extras/overflow.md)                                  |
| `plain`               | Add responsive and compact plain/unstyled helpers                                                                                         | [plain.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/plain.rb), [documentation](extras/plain.md)                                           |
| `searchkick`          | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                      | [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb), [documentation](extras/searchkick.md)                            |
| `semantic`            | Add nav, responsive and compact helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)     | [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb), [documentation](extras/semantic.md)                                  |
| `support`             | Extra support for features like: incremental, infinite, auto-scroll pagination                                                            | [support.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/support.rb), [documentation](extras/support.md)                                     |
| `trim`                | Remove the `page=1` param from links                                                                                                      | [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb), [documentation](extras/trim.md)                                              |

## Synopsis

Extras are not loaded by default, so you should require them explicitly in your `pagy.rb` initializer _(see [Configuration](how-to.md#global-configuration))_:

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/...'
```

## Description

Extras don't define any new module or class, they just re-open the `Pagy` class and modules, adding the extra methods as they were part of the loaded `pagy` gem. This neatly separates the core code from the optional extras, still keeping its usage as simple as it were part of the core.

## Methods

A few extras require the [pagy/extras/shared](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/shared.rb) file. It defines only 3 methods used internally, so you don't actually need to use them directly.

**Notice**: All the other added methods are documented in the respective extras doc.

## Javascript

A few helpers use javascript:

- `pagy_*_compact_nav_js`
- `pagy_*_nav_js`
- `pagy_items_selector`

If you use any of them you should load the [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) file, and run `Pagy.init()` on window load and eventually on [AJAX-load](#using-ajax-with-javascript-enabled-helpers).

### In rails apps

#### With the asset pipeline

If your app uses the sprocket asset-pipeline, add the assets-path in the `pagy.rb` initializer:

```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```

Add the pagy javascript to the `application.js`:

```js
//= require pagy
```

Add an event listener for turbolinks:

```js
window.addEventListener("turbolinks:load", Pagy.init);
```

or a generic one if your app doesn't use turbolinks:
```js
window.addEventListener("load", Pagy.init);
```

#### With Webpacker

If your app uses Webpacker, ensure that the webpacker `erb` loader is installed:

```sh
bundle exec rails webpacker:install:erb
```

Then create a `pagy.js.erb` to render the content of `pagy.js` and add the event listener into it:

```
// app/javascript/src/javascripts/pagy.js.erb
<%= Pagy.root.join('javascripts', 'pagy.js').read %>
window.addEventListener("load", Pagy.init)
```
and import it:
```js
// app/javascript/application.js
import '../src/javascripts/pagy.js.erb'
```

**Notice**:

- You may want to use `turbolinks:load` if your app uses turbolinks despite webpacker
- or you may want just `export { Pagy }` from the `pagy.js.erb` file and import and use it somewhere else.
- You may want to expose the `Pagy` namespace, if you need it available elsewhere (e.g. in js.erb templates):
    ```js
    global.Pagy = Pagy
    ```

### In non-rails apps

Ensure the `pagy/extras/javascripts/pagy.js` script gets served with the page and add an event listener like:

```js
window.addEventListener('load', Pagy.init);
```

or execute the `Pagy.init()` using jQuery:

```js
$( window ).load(function() {
  Pagy.init()
});
```

### Using AJAX with javascript-enabled helpers

If you AJAX-render any of the javascript helpers mentioned above, you should also execute `Pagy.init(container_element);` in the javascript template. Here is an example for a `pagy_bootstrap_nav_js` AJAX-render:

`pagy_remote_nav_js` controller action (notice the `link_extra` to enable AJAX):

```ruby
def pagy_remote_nav_js
  @pagy, @records = pagy(Product.all, link_extra: 'data-remote="true"')
end
```

`pagy_remote_nav_js.html.erb` template for non-AJAX render (first page-load):

```erb
<div id="container">
  <%= render partial: 'nav_js' %>
</div>
```

`_nav_js.html.erb` partial shared for AJAX and non-AJAX rendering:

```erb
<%== pagy_bootstrap_nav_js(@pagy) %>
```

`pagy_remote_nav_js.js.erb` javascript template used for AJAX:

```erb
$('#container').html("<%= j(render 'nav_js')%>");
Pagy.init(document.getElementById('container'));
```

Notice the `document.getElementById('container')` argument: that will re-init the pagy elements just AJAX-rendered in the container div.
