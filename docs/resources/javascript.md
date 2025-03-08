---
label: JavaScript
icon: file-code
order: 100
image: ""
---

#

## JavaScript

---

!!!warning The helpers and paginators named `*_js*` require Pagy JavaScript support.

Simply add the appropriate file(s) and statements as outlined below.
!!!

#### 1. Choose the format that matches your app's configuration

- `pagy.mjs` _ES6 module for buiders like webpacker, esbuild, parcel, etc._
- `pagy.min.js` _A compact (~2.6k) minified [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file_
- `pagy.js` _A plain [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file, ideal for debugging, accompanied by `pagy.js.map`_
- `pagy.js.map` _A source map file designed for debugging purposes_
- `pagy.d.ts` _Pagy TypeScript type definitions for advanced integration or customization_

#### 2. Make the file available to your app

Depending on your app's architecture, you have a couple of options:

- **Add the Pagy JavaScript path to the assets path** 
  - _Compatible with Propshaft, Importmaps, Sprockets, and similar tools._
  ```ruby
  Rails.application.config.assets.paths << Pagy::ROOT.join('javascript')
  ```
- **Alternatively, uncomment/edit the following lines in the [pagy.rb initializer](../toolbox/initializer.md)**
  - _This works with builders like esbuild, Webpack, jsbundling-rails, etc._
  ```ruby 
  # Example for Rails
  javascript_dir = Rails.root.join('app/javascript')
  Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
  ```
- **Load it like any other JavaScript file or module you already use in your app**

#### 3. Set up the `Pagy.init` Listener

The primary purpose of the JavaScript support is to utilize `Pagy.init` as an event listener attached to a suitable `window` event:

```javascript
// Plain JavaScript
window.addEventListener("load", Pagy.init)

// Turbo
window.addEventListener("turbo:load", Pagy.init)

// Turbolinks
window.addEventListener("turbolinks:load", Pagy.init)

// Custom listener
window.addEventListener("yourEventListener", Pagy.init)
```
