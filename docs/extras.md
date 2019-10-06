---
title: Extras
---
# Extras

Pagy comes with a few optional extensions/extras:

| Extra                 | Description                                                                                                                                | Links                                                                                                                                                                                   |
|:----------------------|:-------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `arel`                | Better performance of grouped ActiveRecord collections                                                                                     | [arel.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/arel.rb), [documentation](http://ddnexus.github.io/pagy/extras/arel)                                              |
| `array`               | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                       | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](http://ddnexus.github.io/pagy/extras/array)                                           |
| `bootstrap`           | Add nav, nav_js and combo_nav_js helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination) | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](http://ddnexus.github.io/pagy/extras/bootstrap)                               |
| `bulma`               | Add nav, nav_js and combo_nav_js helpers for the Bulma [pagination component](https://bulma.io/documentation/components/pagination)        | [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb), [documentation](http://ddnexus.github.io/pagy/extras/bulma)                                           |
| `countless`           | Paginate without any count, saving one query per rendering                                                                                 | [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb), [documentation](http://ddnexus.github.io/pagy/extras/countless)                               |
| `elasticsearch_rails` | Paginate `elasticsearch_rails` gem results efficiently                                                                                     | [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb), [documentation](http://ddnexus.github.io/pagy/extras/elasticsearch_rails) |
| `foundation`          | Add nav, nav_js and combo_nav_js helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html) | [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb), [documentation](http://ddnexus.github.io/pagy/extras/foundation)                            |
| `headers`             | Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API pagination          | [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb), [documentation](http://ddnexus.github.io/pagy/extras/headers)                                     |
| `i18n`                | Use the `I18n` gem instead of the pagy implementation                                                                                      | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](http://ddnexus.github.io/pagy/extras/i18n)                                              |
| `items`               | Allow the client to request a custom number of items per page with a ready to use selector UI                                              | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](http://ddnexus.github.io/pagy/extras/items)                                           |
| `materialize`         | Add nav, nav_js and combo_nav_js helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)        | [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb), [documentation](http://ddnexus.github.io/pagy/extras/materialize)                         |
| `metadata`            | Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.                                                      | [metadata.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/metadata.rb), [documentation](http://ddnexus.github.io/pagy/extras/metadata)                                  |
| `navs`                | Add nav_js and combo_nav_js javascript unstyled helpers                                                                                    | [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb), [documentation](http://ddnexus.github.io/pagy/extras/navs)                                              |
| `overflow`            | Allow for easy handling of overflowing pages                                                                                               | [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb), [documentation](http://ddnexus.github.io/pagy/extras/overflow)                                  |
| `searchkick`          | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                                       | [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb), [documentation](http://ddnexus.github.io/pagy/extras/searchkick)                            |
| `semantic`            | Add nav, nav_js and combo_nav_js helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)     | [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb), [documentation](http://ddnexus.github.io/pagy/extras/semantic)                                  |
| `support`             | Extra support for features like: incremental, infinite, auto-scroll pagination                                                             | [support.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/support.rb), [documentation](http://ddnexus.github.io/pagy/extras/support)                                     |
| `trim`                | Remove the `page=1` param from links                                                                                                       | [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb), [documentation](http://ddnexus.github.io/pagy/extras/trim)                                              |
| `uikit`               | Add nav, nav_js and combo_nav_js helpers for the UIkit [pagination component](https://getuikit.com/docs/pagination)                        | [uikit.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/uikit.rb), [documentation](http://ddnexus.github.io/pagy/extras/uikit)                                           |

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

## Javascript

A few helpers use javascript, and they are clearly recognizable by the `js` suffix:

- `pagy*_nav_js`
- `pagy*_combo_nav_js`
- `pagy_items_selector_js`

If you use any of them you should load the [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) file, and run `Pagy.init()` on window load and eventually on [AJAX-load](#using-ajax-with-javascript-enabled-helpers).

**CAVEATS**
- If you override any `*_js` helper, ensure to override/enforce the relative javascript function, even with a simple copy and paste. If the relation between the helper and the function changes in a next release (e.g. arguments, naming, etc.), your app will still work with your own overriding even without the need to update it.
- See also [Preventing crawlers to follow look-alike links](how-to.md#preventing-crawlers-to-follow-look-alike-links)

### Add the oj gem

Although it's not a requirement, if you are on ruby 2.0+ (not jruby), and if you use any `*_nav_js` helper, you should add the `gem 'oj'` to your Gemfile. When available, Pagy will automatically use it to boost the performance. (Notice: It does nothing for normal, non-js helpers.)

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

Then create a `pagy.js.erb` in order to render the content of `pagy.js` and add the event listener into it:

```erb
<%= Pagy.root.join('javascripts', 'pagy.js').read %>
window.addEventListener("load", Pagy.init)
```

and import it in `app/javascript/application.js`:

```js
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

Ensure the `pagy/extras/javascripts/pagy.js` script gets served with the page.

Add an event listener like:

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
