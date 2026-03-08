---
label: JavaScript
icon: file-code
order: 80
---

#

## JavaScript

---

!!!warning The helpers and paginators suffixed with `*_js` require JavaScript support.

Simply add to your code the appropriate file(s) and statements as outlined below.
!!!

>>> Set up the `Pagy.init` listener

Attach the `Pagy.init` to a suitable `window` event in your page:

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

>>> Download a Pagy JavaScript file 

Pick the ES6 module with builders and pipelines; the IIFE file otherwise.<br>
_(Source map and types files are for developing pagy itself.)_

:::compact-dl
[!file ES6 module](../gem/javascripts/pagy.mjs)
[!file Minified IIFE file](../gem/javascripts/pagy.min.js)
[!file Plain IIFE file](../gem/javascripts/pagy.js)
[!file Source map](../gem/javascripts/pagy.js.map)
[!file TypeScript types](../gem/javascripts/pagy.d.ts)
:::

Save the file with your usual modules/javascripts assets.

>>> Load it in your app

You have a couple of options to make the file available to your app. Just pick one to uncomment in the [pagy.rb initializer](initializer.md):

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

After that, you can load it like any other JavaScript file or module you already use in your app.
 
>>>
