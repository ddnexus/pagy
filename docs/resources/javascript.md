---
title: JavaScript
icon: file-code
order: 100
image: ""
---

!!!warning The helpers and paginators named `*_js*` require Pagy JavaScript support.

Simply add the appropriate files and statements as outlined below.
!!!

#### 1. Choose the format that matches your app's configuration or use case

- `pagy.mjs`
  - ES6 module for webpacker, esbuild, parcel, etc.
- `pagy.min.js`
  - A compact (~2.6k) minified [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file
- `pagy.js`
  - A plain [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file, ideal for debugging, accompanied by `pagy.js.map`
- `pagy.js.map`
  - A source map file designed for debugging purposes
- `pagy.d.ts`
  - Pagy TypeScript type definitions for advanced integration or customization

#### 2. Make the files available to your app

Depending on your app's architecture, you have a couple of options:

1. Add the Pagy JavaScript path to the assets path:
  ```ruby
  Rails.application.config.assets.paths << Pagy::ROOT.join('javascript')
  ```
  - _Compatible with Propshaft, Importmaps, Sprockets, and similar tools._

2. Alternatively, uncomment or modify the following lines in the [pagy.rb initializer](../toolbox/initializer.md):
  ```ruby 
  # Example for Rails
  javascript_dir = Rails.root.join('app/javascript')
  Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
  ```
  - _This works with builders like esbuild, Webpack, jsbundling-rails, etc._

Afterward, the file path will either be available in the assets or copied (and kept synced) to your app's JavaScript directory. Load it like any other JavaScript file or module you already use in your app.

#### 3. Set up the `Pagy.init` Listener

The primary purpose of the JavaScript support is to utilize `Pagy.init` as an event listener attached to a suitable event in your app:

```javascript
// Import the Pagy module when using `pagy.mjs`
import Pagy from "pagy"

// Plain JavaScript
window.addEventListener("load", Pagy.init)

// Turbo
window.addEventListener("turbo:load", Pagy.init)

// Turbolinks
window.addEventListener("turbolinks:load", Pagy.init)

// Custom listener
window.addEventListener("yourEventListener", Pagy.init)
```
