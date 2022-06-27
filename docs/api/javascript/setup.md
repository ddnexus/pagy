---
title: Setup
image: null
order: 4
---
  
# Javascript Setup

## Pick a JS File for your environment

+++ `pagy-module.js`

!!! success
Your app uses modern build tools
!!!

* ES6 module

_ESM File: [pagy-module.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-module.js); Types: [pagy-module.d.ts](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-moduled.ts)_

+++ `pagy.js`
!!! success
Your app needs old browser compatibility
!!!

* It's an [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE);
* Polyfilled and minified (~2.9k).

_JS File: [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js)_

<details>
<summary> Browser compatibility list: </summary>

- and_chr 96
- and_ff 95
- and_qq 10.4
- and_uc 12.12
- android 96
- baidu 7.12
- chrome 97
- chrome 96
- chrome 95
- chrome 94
- edge 97
- edge 96
- firefox 96
- firefox 95
- firefox 94
- firefox 91
- firefox 78
- ie 11
- ios_saf 15.2
- ios_saf 15.0-15.1
- ios_saf 14.5-14.8
- ios_saf 14.0-14.4
- ios_saf 12.2-12.5
- kaios 2.5
- op_mini all
- op_mob 64
- opera 82
- opera 81
- safari 15.2
- safari 15.1
- safari 14.1
- safari 13.1
- samsung 15.0
- samsung 14.0

!!! info
You can generate custom targeted `pagy.js` files for the browsers you want to support by changing the [browserslist](https://github.com/browserslist/browserslist) query in `src/package.json`, then compile it with `npm run build -w src`.
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

_JS File: [pagy-dev.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-dev.js)_
+++

!!! info
We don't publish a `npm` package, because it would be very difficult for you to keep it manually in sync with the ruby gem at every update. Instead we load the files directly from the installed gem.
!!!


## Load the file

Depending on your environment you have a few ways of loading the required JS file:

### Rails with build tools

Pulling the file directly from the `$(bundle show 'pagy')/lib/javascripts` gem installation path:

+++ Esbuild
||| package.json
```json
{
  "build": "NODE_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your original command>"
}
```
|||

+++ Webpack
||| package.json
```json
{
  "build": "PAGY_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your webpack command>"
}
```
|||

||| webpack.config.js
```js
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
|||

+++ Rollup

||| package.json
```json
{
  "build": "PAGY_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your rollup command>"
}
```
|||

||| rollup.confg.js
```js
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
|||
+++

### Rails with assets pipeline

In older versions of Rails, you can configure the assets to look into the installed pagy gem files:

+++ Sprockets
||| pagy.rb (initializer)
```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts') # uncomment.
```
|||

||| manifest.js (or `application.js` for old sprocket sprockets):
```js
//= require pagy
```
|||

+++ Importmaps
||| pagy.rb (initializer)
```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts') #uncomment
```
|||

||| app/assets/config/manifest.js
```js
//= link pagy-module.js
```
|||

||| config/importmap.rb
```ruby
pin 'pagy-module'
```
|||

+++ Propshaft
||| pagy.rb (initializer)
```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```
|||

||| application.html.erb
```erb
<%= javascript_include_tag "pagy" %>
```
|||
+++

### Non-Rails apps

* Just ensure `Pagy.root.join('javascripts', 'pagy.js')` is served with the page.

## Initialize Pagy

After the file is loaded, you have to initialize `Pagy`:

+++ Stimulus JS
||| pagy_initializer_controller.js
```js
import { Controller } from "@hotwired/stimulus"
import Pagy from "pagy-module"  // if using sprockets, you can remove above line, but make sure you have the appropriate directive if your manifest.js file.

export default class extends Controller {
  connect() {
    Pagy.init(this.element)
  }
}
```
|||

||| View
```erb
<div data-controller="pagy-initializer">
  <%== pagy_nav_js(@pagy) %>
</div>
```
|||

+++ Others
```js
// if you choose pagy-module.js 
import Pagy from "pagy-module"

// plain javascript
window.addEventListener(load, Pagy.init)

// Turbo
window.addEventListener(turbo:load, Pagy.init)

// Turbolinks
window.addEventListener(turbolinks:load, Pagy.init)

// custom listener
window.addEventListener(yourEventListener, Pagy.init) 
```
+++
