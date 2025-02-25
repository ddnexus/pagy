---
title: Javascript
icon: file-code
order: 100
image: none
---

# Javascript

!!!warning The helpers/paginators named `*_js` require pagy javascript support!

Just add the proper file and statements indicated below.
!!!

#### 1. Pick the format that suits your app configuration/use

- `pagy.mjs`
  - ES6 module for webpacker, esbuild, parcel, etc.
- `pagy.min.js`
  - ~2.6k minified [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file
- `pagy.js`
  - Plain [IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) file to use for debugging with its `pagy.js.map`
- `pagy.js.map`
  - Source map file for debugging
- `pagy.d.ts`
  - Pagy types if you need to work on it in typescript
    [!file](/javascripts/pagy.d.ts)

#### 2. Make the files available to your app

Depending on the architecture of your app, you have a couple of alternatives:

1. Either add the pagy javascripts path to the assets path: 
  ```ruby
  Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
  ```
  - This works with Propshaft, Importmaps, Sprocket, etc.

2. or uncomment/edit the following lines in the [pagy.rb initializer](../toolbox/initializer.md):
  ```ruby 
  # Example for Rails
  javascript_dir = Rails.root.join('app/javascript')
  Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
  ```
  - This works with builders like esbuild, Webpack, jsbundling-rails, etc

After that, either the filepath is available in the assets, or the file is copied (and kept synced) in the javascript dir of your app. Load it as you do with any other javascript files/modules that you alredy define/use in your app.

#### 3. Add the Pagy.init listener

The final goal of the javascript support is using `Pagy.init` as an event listener, attached to a suitable event for your app:

```javascript
// Import the Pagy module if you use pagy.mjs 
import Pagy from "docs/api/instance"

// Plain javascript
window.addEventListener("load", Pagy.init)

// Turbo
window.addEventListener("turbo:load", Pagy.init)

// Turbolinks
window.addEventListener("turbolinks:load", Pagy.init)

// custom listener
window.addEventListener(yourEventListener, Pagy.init)
```
