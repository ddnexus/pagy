---
label: JavaScript
icon: file-code
order: 80
---

#

## JavaScript

---

!!!warning 

The helpers and paginators suffixed with `*_js` require JavaScript support.
!!!

>>> Sync the JavaScript files
  
The following statement will copy and keep synced the JavaScript files in your own `app/javascripts` dir _(or any dir you want use)_.

```rb [pagy.rb initializer](../toolbox/configuration/initializer)
javascript_dir = Rails.root.join('app/javascripts')
Pagy.sync_javascript(javascript_dir, 'pagy.mjs', 'pagy.min.js') if Rails.env.development?
```

After that you should treat the files as your own, according to the configuration used by your app. For example:

```js application.js
import Pagy from "pagy.mjs"
```

>>> Add the `Pagy.init` to an event

You can use `load`, `turbo:load`, `turbolinks:load`, or any appropriate event to init the pagy `*_js` helpers. For example:

```js
window.addEventListener("load", Pagy.init)
```


>>>
