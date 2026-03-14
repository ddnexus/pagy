---
label: JavaScript
icon: file-code
order: 80
---

#

## JavaScript

---

!!!warning The helpers and paginators suffixed with `*_js` require JavaScript support.

Add the appropriate statements to your code as outlined below.
!!!

>>> Configure the app
<br>

+++ Importmaps

```ruby config/importmap.rb
pin "pagy", to: Pagy::ROOT.join("javascripts/pagy.min.js")
```

```js application.js
import "pagy"
```

+++ Sprockets

```rb [pagy.rb initializer](../toolbox/configuration/initializer)
Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
``` 

```js application.js
//= link pagy.mjs
```

+++ Propshaft

```rb [pagy.rb initializer](../toolbox/configuration/initializer)
Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
``` 

```js application.js
import Pagy from "pagy.mjs"
```

+++ Builders

_Webpack, esbuild, jsbundling-rails, ..._

```rb [pagy.rb initializer](../toolbox/configuration/initializer)
javascript_dir = Rails.root.join('app/javascripts')
Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
```

```js application.js
import Pagy from "pagy.mjs"
```
+++

>>> Add the `Pagy.init` listener
<br>

+++ JavaScript

```js
window.addEventListener("load", Pagy.init)
```

+++ Turbo

```js
window.addEventListener("turbo:load", Pagy.init)
```

+++ Turbolinks

```js
window.addEventListener("turbolinks:load", Pagy.init)
```

+++ Custom

```js
window.addEventListener("yourEvent", Pagy.init)
```
+++

>>>
