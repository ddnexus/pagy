---
label: JavaScript
icon: file-code
order: 80
---

#

## JavaScript

---

!!!warning The helpers and paginators suffixed with `*_js` require JavaScript support.

Add the appropriate file(s) and statements to your code as outlined below.
!!!

>>> Configure the initializer

Depending on your JavaScript environment, uncomment the appropriate statement in the [pagy.rb initializer](../toolbox/configuration/initializer):

##### For apps with an assets pipeline...

_Compatible with Propshaft, Importmaps, Sprockets, and similar tools._

```ruby
Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
``` 

##### For apps with a builder...

_For builders like esbuild, Webpack, jsbundling-rails, etc._

```ruby 
# Example for Rails
javascript_dir = Rails.root.join('app/javascripts')
Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
```

>>> Load Pagy in your app

##### Using the module...
<br>

```javascript
import Pagy from "path/to/pagy.mjs"
```

##### Using the minified IIFE...
<br>

```erb
<%= javascript_include_tag "pagy.min.js" ...%>
```

```html
<script src="/path/to/pagy.min.js"></script>
```

>>> Add the `Pagy.init` listener

Use a suitable event in your page:

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
 
>>>
