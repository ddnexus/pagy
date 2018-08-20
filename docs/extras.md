---
title: Extras
---
# Extras

Pagy comes with a few optional extensions/extras:

| Extra          | Description                                                                                                                | Links                                                                                                                                   |
| :------------- | :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| `array`        | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                       | [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb), [documentation](extras/array.md)                      |
| `bootstrap`    | Nav, responsive and compact helpers and templates for Bootstrap pagination                                                 | [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb), [documentation](extras/bootstrap.md)          |
| `bulma`        | Nav, responsive and compact helpers and templates for [Bulma](https://bulma.io) pagination component                       | [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb), [documentation](extras/bulma.md)                      |
| `foundation`   | Nav, responsive and compact helpers and templates for Foundation pagination                                                | [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb), [documentation](extras/foundation.md)       |
| `i18n`         | Use the `I18n` gem instead of the pagy implementation                                                                      | [i18n.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/i81n.rb), [documentation](extras/i18n.md)                         |
| `items`        | Allow the client to request a custom number of items per page with a ready to use selector UI                              | [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb), [documentation](extras/items.md)                      |
| `materialize`  | Nav, responsive and compact helpers for Materialize CSS [pagination component](https://materializecss.com/pagination.html) | [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb), [documentation](extras/materialize.md)    |
| `navs`         | Add responsive and compact generic/unstyled nav helpers                                                                    | [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb), [documentation](extras/navs.md)                         |
| `out_of_range` | Allow for easy handling of out of range pages                                                                              | [out_of_range.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/out_of_range.rb), [documentation](extras/out_of_range.md) |
| `searchkick`   | Paginate arrays efficiently avoiding expensive array-wrapping and without overriding                                       | [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb), [documentation](extras/searchkick.md)       |
| `trim`         | Remove the `page=1` param from links                                                                                       | [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb), [documentation](extras/trim.md)                         |

## Synopsys

Extras are not loaded by default, so you should require them explicitly in your `pagy.rb` initializer _(see [Configuration](how-to.md#global-configuration))_:

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/...'
```

## Description

Extras don't define any new module or class, they just re-open the `Pagy` class and modules, adding the extra methods as they were part of the loaded `pagy` gem. This neatly separates the core code from the optional extras, still keeping its usage as simple as it were part of the core.

## Methods

All the added methods are documented in the respective extras.

## Javascript

The `compact`, `items` and `responsive` extras use javascript, so if you use any of them you should load the [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) file, and run `Pagy.init()` on window load.

### In rails apps

Add the assets-path in the `pagy.rb` initializer:

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
