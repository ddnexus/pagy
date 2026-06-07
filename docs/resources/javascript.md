---
label: JavaScript
icon: file-code
order: 80
---

#

## :icon-file-code:&nbsp;&nbsp;JavaScript

---

!!!tip Add the `oj` gem to your gemfile
It is not a requirement, but if present, the pagy `JSON` generation will be faster.
!!!

### Setup

>>> Pick a file...

+++ pagy.mjs

!!!success Good for apps **with** a minifier _(Sprockets, builers, ...)_
!!!

Make `Pagy` available in your JavaScript environment with...

```js application.js
import Pagy from "pagy.mjs"
```

+++ pagy.min.js

!!!success Good for apps **without** a minifier _(Propshaft, Importmaps, ...)_
!!!

Make `Pagy` available in your JavaScript environment with...

```erb ERB template / HTML page
<%= javascript_include_tag "pagy.min.js" ...%>

<!-- or if your framework does not provide helpers -->
<script src="/path/to/pagy.min.js"></script>
```

+++ pagy.js

!!!warning Use it only for debugging Pagy itself.
!!!

+++

{{ include "snippets/pick-a-conf" resource: ":javascript" resource_dir: "javascripts" remote_dir: "app/javascript" }}

>>> Run the `Pagy.init` on...

+++ "load" event

Pick which applies to your environment:

```js
window.addEventListener("load", Pagy.init)
window.addEventListener("turbo:load", Pagy.init)
window.addEventListener("turbolinks:load", Pagy.init)
window.addEventListener("your-event", Pagy.init)
```

+++ Stimulus connect

```js
connect() {
  Pagy.init(this.element);
}
```

+++

>>>
