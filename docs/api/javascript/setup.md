---
title: Setup
image: none
order: 4
---

# Javascript Setup

!!!info Notice
A javascript setup is required only for the `pagy*_js` helpers. Just using something like `anchor_string: 'data-remote="true"'` in any instances works out of the box with any helper and without this setup.
!!!

!!!primary
We don't publish a `npm` package, because it would not support automatic sync with the gem version.
!!!

!!!success
Add the `oj` gem to your gemfile for faster performance.
!!!

### How does it work?

All the `pagy*_js` helpers render their component on the client side. The helper methods render just a minimal HTML tag that
contains a `data-pagy` attribute.

Your app should [serve or bundle](#2-configure) a small [javascript file](#1-pick-a-javascript-file) and [run the `Pagy.init()
`](#3-initialize-pagy) function that will take care of converting the the `data-pagy` attribute data and make it work
in the browser.

### 1. Pick a Javascript File

+++ `pagy.mjs`

!!! success
Your app uses modern build tools
!!!

* ES6 module to use with webpacker, esbuild, parcel, etc.

[!file](/gem/javascripts/pagy.mjs)

```ruby 
module_path = Pagy.root.join('javascripts', 'pagy.mjs')
```

[!file](/gem/javascripts/pagy.d.ts)

```ruby 
types_path = Pagy.root.join('javascripts', 'pagy.d.ts')
```

+++ `pagy.min.js`
!!! success
Your app needs standard script or old browser compatibility
!!!

* It's an [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file meant to be loaded as is, directly in your
  production pages and without any further processing
* Minified (~2k) and polyfilled to work also with quite old browsers

[!file](/gem/javascripts/pagy.min.js)

```ruby 
script_path = Pagy.root.join('javascripts', 'pagy.min.js')
```

+++ `pagy.min.js.map`

!!! success
You need to debug the javascript helpers while using the `pagy.min.js` file
!!!

[!file](/gem/javascripts/pagy.min.js.map)

```ruby 
script_path = Pagy.root.join('javascripts', 'pagy.min.js.map')
```

+++

### 2. Configure

Depending on your environment you have a few ways of configuring your app:

#### Rails with assets pipeline

In older versions of Rails, you can configure the app to look into the installed pagy gem javascript files:

+++ Sprockets

```ruby pagy.rb (initializer)
Rails.application.config.assets.paths << Pagy.root.join('javascripts') # uncomment.
```

```js manifest.js (or "application.js" for old sprocket sprockets):
//= require pagy
```

+++ Importmaps

```ruby pagy.rb (initializer)
Rails.application.config.assets.paths << Pagy.root.join('javascripts') #uncomment
```

```js app/assets/config/manifest.js
//= link pagy.mjs
```

```ruby config/importmap.rb
pin 'pagy'
```

+++ Propshaft

```ruby pagy.rb (initializer)
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```

```erb application.html.erb
<%= javascript_include_tag "pagy" %>
```

+++

#### Builders

In order to bundle the `pagy.mjs` your builder has to find it either with a link or local copy, or by looking into the pagy
javascript path:

+++ Generic
You can create a symlink or a copy of the `pagy.mjs` file (available in the pagy gem) into an app compiled dir and use it as
a regular app file. That way any builder will pick it up. For example:

```ruby config/initializers/pagy.rb
# Create/refresh the `app/javascript/pagy.mjs` symlink/copy every time 
# the app restarts (unless in production), ensuring syncing when pagy is updated.
# Replace the FileUtils.ln_sf with FileUtils.cp if your OS doesn't support file linking. 
FileUtils.ln_sf(Pagy.root.join('javascripts', 'pagy.mjs'), Rails.root.join('app', 'javascript')) \
unless Rails.env.production?
```

+++ esbuild
Prepend the `NODE_PATH` environment variable to the `scripts.build` command:

```json package.json
{
    "build": "NODE_PATH=\"$(bundle show 'pagy')/javascripts\" <your original command>"
}
```

+++ Webpack
Prepend the `NODE_PATH` environment variable to the `scripts.build` command:

```json package.json
{
    "build": "NODE_PATH=\"$(bundle show 'pagy')/javascripts\" <your original command>"
}
```

```js webpack.config.js
module.exports = {
  ...,                          // your original config
  resolve: {                    // add resolve.modules
    modules: [
      "node_modules",           // node_modules dir
      process.env.PAGY_PATH     // pagy dir
    ]
  }
}
```

#### Non-Rails apps

* Just ensure `Pagy.root.join('javascripts', 'pagy.js')` is served with the page.

### 3. Initialize Pagy

After the helper is loaded you have to initialize `Pagy` to make it work:

+++ Stimulus JS

```js pagy_initializer_controller.js
import {Controller} from "@hotwired/stimulus"
import Pagy from "pagy"  // if using sprockets, you can remove above line, but make sure you have the appropriate directive if your manifest.js file.

export default class extends Controller {
  connect() {
    Pagy.init(this.element)
  }
}
```

```erb View
<div data-controller="pagy-initializer">
  <%== pagy_nav_js(@pagy) %>
</div>
```

+++ jsbundling-rails
Import and use the pagy module:

```js app/javascript/application.js
import Pagy from "pagy";

window.addEventListener("turbo:load", Pagy.init);
```

+++ Others

```js
// if you choose pagy.mjs 
import Pagy from "pagy"

// plain javascript
window.addEventListener("load", Pagy.init)

// Turbo
window.addEventListener("turbo:load", Pagy.init)

// Turbolinks
window.addEventListener("turbolinks:load", Pagy.init)

// custom listener
window.addEventListener(yourEventListener, Pagy.init) 
```

+++

#### Caveats

!!!warning HTML Fallback

If Javascript is disabled in the client browser, certain helpers will be useless. Consider implementing your own HTML fallback:

```erb
<noscript><%== pagy_nav(@pagy) %></noscript>
```

!!!

!!!danger Overriding `*_js` helpers is not recommended
The `pagy*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!
