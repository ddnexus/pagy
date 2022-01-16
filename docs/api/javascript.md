---
title: Javascript
---

# Javascript

## Overview

A few helpers use javascript, and they are clearly recognizable by the `js` suffix:

- `pagy*_nav_js`
- `pagy*_combo_nav_js`
- `pagy_items_selector_js`

If you use any of them you should follow this documentation, if not, consider that Javascript is not used anywhere else, so you can skip this.

### Basic principle

All the `pagy*_js` helpers render their component on the client side. The helper methods serve just a minimal HTML tag that contains a `data-pagy` attribute. The [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) code takes care to convert the data embedded in the `data-pagy` attribute and makes it work in the browser.

## Usage

### Basic usage

Load the [pagy.js](https://github.com/ddnexus/pagy/tree/master/lib/javascripts#pagyjs) minified (2.9k) file _(see the documentation for [rails apps](#in-rails-apps) or [non-rails-apps](#in-non-rails-apps))_, and run `Pagy.init()` on window-load and eventually on [AJAX-load](#using-ajax).

### Module import

If you prefer to use pagy as an importable javascript module, pagy provides the ES6 [pagy-module.js](https://github.com/ddnexus/pagy/tree/master/lib/javascripts#pagy-modulejs) and the definition types file [pagy-module.d.ts](https://github.com/ddnexus/pagy/tree/master/lib/javascripts#pagy-moduledts).

### Debugging Javascript

Use the [pagy-dev.js](https://github.com/ddnexus/pagy/tree/master/lib/javascripts#pagy-devjs) in place of `pagy.js`. It is a readable javascript file meant to be used only for debugging with modern browsers.

### Faster performance with the oj gem

Although it's not a requirement, you should consider adding the `gem 'oj'` to your Gemfile. When available, Pagy will automatically use it to boost the performance. (Notice: It does nothing for normal, non-js helpers.)

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

Then create a `pagy.js.erb` (in `app/javascript/packs/`) in order to import `pagy-module.js` and add an event listener to it (to allow the library to reinitialize when you click a new link):

```erb
import Pagy from "<%= Pagy.root.join('javascripts', 'pagy-module.js') %>"
window.addEventListener("turbo:load", Pagy.init) # if using turbo-rails OR

# window.addEventListener("turbolinks:load", Pagy.init) # if turbolinks OR
# window.addEventListener("load", Pagy.init) # if using no library
```

and import it in `app/javascript/application.js`:

```js
import './pagy.js.erb'
```

**Notice**:

- You may want to use `turbolinks:load` if your app uses turbolinks despite webpacker
- or you may want to expose the `Pagy` namespace, if you need it available elsewhere (e.g. in js.erb templates):

    ```js
    global.Pagy = Pagy
    ```

### In non-rails apps

Ensure the `Pagy.root.join('javascripts', 'pagy.js')` script gets served with the page.

Add an event listener like:

```js
window.addEventListener('load', Pagy.init);
```

### CAVEATS

#### Functions

If you override any `*_js` helper, ensure to override/enforce the javascript functions that it uses. If the relation between the helper and the functions change in a next release (e.g. arguments, naming, etc.), your app will still work with your own overriding even without the need to update it.

#### HTML fallback

Notice that if the client browser doesn't support Javascript or if it is disabled, certain helpers will serve nothing useful for the user. If your app does not require Javascript support and you still want to use javascript helpers, then you should consider implementing your own HTML fallback. For example:

    ```erb
    <noscript><%== pagy_nav(@pagy) %></noscript>
    ```

# Javascript Navs

The following `pagy*_nav_js` helpers:

- `pagy_nav_js`
- `pagy_bootstrap_nav_js`
- `pagy_bulma_nav_js`
- `pagy_foundation_nav_js`
- `pagy_materialize_nav_js`
- `pagy_semantic_nav_js`

look like a normal `pagy*_nav` but have a few added features:

1. Client-side rendering
2. Optional responsiveness
3. Better performance and resource usage _(see [Maximizing Performance](../how-to.md#maximizing-performance))_

Here is a screenshot (from the `bootstrap`extra) showing responsiveness at different widths:

![bootstrap_nav_js](../assets/images/bootstrap_nav_js-g.png)

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer, require the specific extra for the style you want to use:

```ruby
# you only need one of the following extras
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
require 'pagy/extras/foundation'
require 'pagy/extras/materialize'
require 'pagy/extras/navs'
require 'pagy/extras/semantic'
require 'pagy/extras/uikit'
```

Use the `pagy*_nav_js` helpers in any view:

```erb
<%== pagy_nav_js(@pagy) %>
<%== pagy_bootstrap_nav_js(@pagy) %>
<%== pagy_bulma_nav_js(@pagy) %>
<%== pagy_foundation_nav_js(@pagy) %>
<%== pagy_materialize_nav_js(@pagy) %>
<%== pagy_semantic_nav_js(@pagy) %>
```

## Variables

| Variable | Description                                                        | Default |
|:---------|:-------------------------------------------------------------------|:--------|
| `:steps` | Hash variable to control multiple pagy `:size` at different widths | `false` |

### :steps

The `:steps` is an optional non-core variable used by the `pagy*_nav_js` navs. If it's `false`, the `pagy*_nav_js` will behave exactly as a static `pagy*_nav` respecting the single `:size` variable, just faster and lighter. If it's defined as a hash, it allows you to control multiple pagy `:size` at different widths.

You can set the `:steps` as a hash where the keys are integers representing the widths in pixels and the values are the Pagy `:size` variables to be applied for that width.

As usual, depending on the scope of the customization, you can set the variables globally or for a single pagy instance, or even pass it to the `pagy*_nav_js` helper as an optional keyword argument.

For example:

```ruby
# globally
Pagy::DEFAULT[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }

# or for a single instance
pagy, records = pagy(collection, steps: { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] } )

# or use the :size as any static pagy*_nav
pagy, records = pagy(collection, steps: false )
```

```erb
or pass it to the helper
<%== pagy_nav_js(@pagy, steps: {...}) %>
```

The above statement means that from `0` to `540` pixels width, Pagy will use the `[2,3,3,2]` size, from `540` to `720` it will use the `[3,5,5,3]` size and over `720` it will use the `[5,7,7,5]` size. (Read more about the `:size` variable in the [How to control the page links](../how-to.md#control-the-page-links) section).

**IMPORTANT**: You can set any number of steps with any arbitrary width/size. The only requirement is that the `:steps` hash must contain always the `0` width or a `Pagy::VariableError` exception will be raised.

#### Setting the right sizes

Setting the widths and sizes can create a nice transition between widths or some apparently erratic behavior.

Here is what you should consider/ensure:

1. The pagy size changes in discrete `:steps`, defined by the width/size pairs.

2. The automatic transition from one size to another depends on the width available to the pagy nav. That width is the _internal available width_ of its container (excluding eventual horizontal padding).

3. You should ensure that - for each step - each pagy `:size` produces a nav that can be contained in its width.

4. You should ensure that the minimum internal width for the container div be equal (or a bit bigger) to the smaller positive width. (`540` pixels in our previous example).

5. If the container width snaps to specific widths in discrete steps, you should sync the quantity and widths of the pagy `:steps` to the quantity and internal widths for each discrete step of the container.

#### Javascript Caveats

In case of a window resize, the `pagy_*nav_js` elements on the page are re-rendered (when the container width changes), however if the container width changes in any other way that does not involve a window resize, then you should re-render the pagy element explicitly. For example:

```js
document.getElementById('my-pagy-nav-js').render();
```

# Javascript Combo Navs

The following `pagy*_combo_nav_js` offer an alternative pagination UI that combines navigation and pagination info in a single compact element:

- `pagy_combo_nav_js`
- `pagy_bootstrap_combo_nav_js`
- `pagy_bulma_combo_nav_js`
- `pagy_foundation_combo_nav_js`
- `pagy_materialize_combo_nav_js`
- `pagy_semantic_combo_nav_js`

They are the fastest and lightest `nav` on modern environments, recommended when you care about efficiency and server load _(see [Maximizing Performance](../how-to.md#maximizing-performance))_.

Here is a screenshot (from the `bootstrap` extra):

![bootstrap_combo_nav_js](../assets/images/bootstrap_combo_nav_js-g.png)

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer, require the specific extra for the style you want to use:

```ruby
# you only need one of the following extras
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
require 'pagy/extras/foundation'
require 'pagy/extras/materialize'
require 'pagy/extras/navs'
require 'pagy/extras/semantic'
require 'pagy/extras/uikit'
```

Use the `pagy*_combo_nav_js` helpers in any view:

```erb
<%== pagy_combo_nav_js(@pagy, ...) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, ...) %>
<%== pagy_bulma_combo_nav_js(@pagy, ...) %>
<%== pagy_foundation_combo_nav_js(@pagy, ...) %>
<%== pagy_materialize_combo_nav_js(@pagy, ...) %>
<%== pagy_semantic_combo_nav_js(@pagy, ...) %>
```

## Methods

### pagy*_nav_js(pagy, ...)

The method accepts also a few optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attribute to the `nav` tag
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)
- `:steps` the [:steps](#steps) variable

**CAVEATS**: the `pagy_bootstrap_nav_js` and `pagy_semantic_nav_js` assign a class attribute to their links, so do not add another class attribute with the `:link_extra`. That would be illegal HTML and ignored by most browsers.

### pagy*_combo_nav_js(pagy, ...)

The method accepts also a couple of optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attribute to the `nav` tag
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)

**CAVEATS**: the `pagy_semantic_combo_nav_js` assigns a class attribute to its links, so do not add another class attribute with the `:link_extra`. That would be illegal HTML and ignored by most browsers.

# Using AJAX

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

**IMPORTANT**: The `document.getElementById('container')` argument will re-init the pagy elements just AJAX-rendered in the container div. If you miss it, it will not work.
