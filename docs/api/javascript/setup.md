---
title: Setup
image: null
order: 4
---

# Javascript Setup

!!!info Notice
A javascript setup is required only for the `pagy*_js` helpers. Just using `'data-remote="true"'` in any other helper works out of the box.
!!!

!!! success 
Add the `oj` gem to your gemfile for faster performance.
!!!

### How does it work?

All the `pagy*_js` helpers render their component on the client side. The helper methods render just a minimal HTML tag that contains a `data-pagy` attribute.

Your app should serve a small javascript file that will take care of converting the data embedded in the `data-pagy` attribute and make it work in the browser.

!!! info
We don't publish a `npm` package, because it would not support automatic sync with the gem version.
!!!

### 1. Pick a Javascript File

+++ `pagy-module.js`

!!! success
Your app uses modern build tools
!!!

* ES6 module

_ESM File: [pagy-module.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-module.js); Types: [pagy-module.d.ts](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-moduled.ts)_

+++ `pagy.js`
!!! success
Your app needs standard script or old browser compatibility
!!!

* It's an [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE);
* Minified (~2k).

_JS File: [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js)_

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

### 2. Load the file

Depending on your environment you have a few ways of loading the required JS file:

#### Rails with assets pipeline

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

#### Non-Rails apps

* Just ensure `Pagy.root.join('javascripts', 'pagy.js')` is served with the page.

### 3. Initialize Pagy

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

#### Caveats

!!!warning HTML Fallback

If Javascript is disabled in the client browser, certain helpers will be useless. Consider implementing your own HTML fallback:

```erb
<noscript><%== pagy_nav(@pagy) %></noscript>
```
!!!

!!!danger Overriding `*_js` helpers is not recommended
The `pagy*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile and might break in a next release.
!!!
