---
title: Setup
image: none
order: 4
---

# Javascript Setup

!!!info Notice
A javascript setup is required only for the `pagy*_js` helpers. Just using something like `anchor_string: 'data-remote="true"'` in any other helper works out of
the box.
!!!

!!! success
Add the `oj` gem to your gemfile for faster performance.
!!!

### How does it work?

All the `pagy*_js` helpers render their component on the client side. The helper methods render just a minimal HTML tag that
contains a `data-pagy` attribute.

Your app should serve or bundle a small javascript file that will take care of converting the data embedded in the `data-pagy`
attribute and make it work in the browser.

!!! info
We don't publish a `npm` package, because it would not support automatic sync with the gem version.
!!!

### 1. Pick a Javascript File

+++ `pagy-module.js`

!!! success
Your app uses modern build tools
!!!

* ES6 module to use with webpacker, esbuild, parcel, etc.

[!file](/gem/javascripts/pagy-module.js)

[!file](/gem/javascripts/pagy-module.d.ts)

+++ `pagy.js`
!!! success
Your app needs standard script or old browser compatibility
!!!

* It's an [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file meant to be loaded as is, directly in your
  production pages and without any further processing
* Minified (~2k) and polyfilled to work also with quite old browsers

[!file](/gem/javascripts/pagy.js)

<details>
<summary> Browser compatibility list: </summary>

- and_chr 103
- and_ff 101
- and_qq 10.4
- and_uc 12.12
- android 103
- chrome 103
- chrome 102
- chrome 101
- edge 103
- edge 102
- firefox 102
- firefox 101
- firefox 91
- ios_saf 15.5
- ios_saf 15.4
- ios_saf 15.2-15.3
- ios_saf 14.5-14.8
- ios_saf 14.0-14.4
- ios_saf 12.2-12.5
- kaios 2.5
- op_mini all
- op_mob 64
- opera 87
- opera 86
- opera 85
- safari 15.5

!!! info
You can generate custom targeted `pagy.js` files for the browsers you want to support by changing
the [browserslist](https://github.com/browserslist/browserslist) query in `src/package.json`, then compile it
with `cd src && npm run build`.
!!!

</details>

+++ `pagy-dev.js`

!!! success
You need to debug the javascript helpers
!!!

!!! warning Debug only!

* Large size
* It contains the source map to debug typescript
* It works only on new browsers
  !!!

[!file](/gem/javascripts/pagy-dev.js)
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
//= link pagy-module.js
```

```ruby config/importmap.rb
pin 'pagy-module'
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

In order to bundle the `pagy-module.js` your builder has to find it either with a link or local copy, or by looking into the pagy
javascript path:

+++ Generic
You can create a symlink or a copy of the `pagy-module.js` file (available in the pagy gem) into an app compiled dir and use it as
a regular app file. That way any builder will pick it up. For example:

```ruby config/initializers/pagy.rb
# Create/refresh the `app/javascript/pagy-module.js` symlink/copy every time 
# the app restarts (unless in production), ensuring syncing when pagy is updated.
# Replace the FileUtils.ln_sf with FileUtils.cp if your OS doesn't support file linking. 
FileUtils.ln_sf(Pagy.root.join('javascripts', 'pagy-module.js'), Rails.root.join('app', 'javascript')) \
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

```js webpack.confg.js
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

#### Legacy way

Ensure that the `erb` loader is installed:

```sh
bundle exec rails webpacker:install:erb
```

Generate a local pagy javascript file using `erb` with webpacker:
```erb app/javascript/packs/pagy.js.erb
<%= Pagy.root.join('javascripts', 'pagy.js').read %>
window.addEventListener(YOUR_EVENT_LISTENER, Pagy.init)
```
_where `YOUR_EVENT_LISTENER` is the load event that works with your app (
e.g. `"turbo:load"`, `"turbolinks:load"`, `"load"`, ...)._

```js app/javascript/application.js
import './pagy.js.erb'
```

+++ Rollup
Prepend the `NODE_PATH` environment variable to the `scripts.build` command:
```json package.json
{
    "build": "NODE_PATH=\"$(bundle show 'pagy')/javascripts\" <your original command>"
}
```

Configure the `plugins[resolve]`:

```js rollup.confg.js
export default {
  ...,                                    // your original config
  plugins: [
    resolve({
              moduleDirectories: [        // add moduleDirectories
                "node_modules",           // node_modules dir
                process.env.PAGY_PATH     // pagy dir
              ]
            })
  ]
}
```
+++

#### Non-Rails apps

* Just ensure `Pagy.root.join('javascripts', 'pagy.js')` is served with the page.

### 3. Initialize Pagy

After the helper is loaded you have to initialize `Pagy` to make it work:

+++ Stimulus JS
```js pagy_initializer_controller.js
import {Controller} from "@hotwired/stimulus"
import Pagy from "pagy-module"  // if using sprockets, you can remove above line, but make sure you have the appropriate directive if your manifest.js file.

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
import Pagy from "pagy-module";

window.addEventListener("turbo:load", Pagy.init);
```

+++ Others

```js
// if you choose pagy-module.js 
import Pagy from "pagy-module"

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
