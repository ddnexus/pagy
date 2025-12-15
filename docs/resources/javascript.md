---
label: JavaScript
icon: file-code
order: 80
---

#

## JavaScript

---

!!!warning The helpers and paginators named `*_js` require JavaScript support.

Simply add to your code the appropriate file(s) and statements as outlined below.
!!!

#### 1. Choose the format that matches your app's configuration

:::compact-dl
[!file ES6 module](../gem/javascripts/pagy.mjs)
[!file Minified IIFE file](../gem/javascripts/pagy.min.js)
[!file Plain IIFE file](../gem/javascripts/pagy.js)
[!file Source map](../gem/javascripts/pagy.js.map)
[!file TypeScript types](../gem/javascripts/pagy.d.ts)
:::

#### 2. Make the file available to your app

Depending on your app's architecture, you have a couple of options. Just pick one to uncomment in the [pagy.rb initializer](initializer.md):

- **For apps with an assets pipeline...**
  - _Compatible with Propshaft, Importmaps, Sprockets, and similar tools._
  ```ruby
  Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
  ```
- **For apps with a builder...**
  - _This works with builders like esbuild, Webpack, jsbundling-rails, etc._
  ```ruby 
  # Example for Rails
  javascript_dir = Rails.root.join('app/javascripts')
  Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
  ```
- **Load it like any other JavaScript file or module you already use in your app**

#### 3. Set up the `Pagy.init` listener

The primary purpose of the JavaScript support is to utilize `Pagy.init` as an event listener attached to a suitable `window` event:

```javascript
// Plain JavaScript
window.addEventListener("load", Pagy.init)

// Turbo
window.addEventListener("turbo:load", Pagy.init)

// Turbolinks
window.addEventListener("turbolinks:load", Pagy.init)

// Custom event
window.addEventListener("yourEvent", Pagy.init)
```
