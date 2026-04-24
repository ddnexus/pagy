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

<!-- or if your app does not provide helpers -->
<script src="/path/to/pagy.min.js"></script>
```

+++ pagy.js

!!!warning Use it only for debugging Pagy itself.
!!!

+++

>>> Pick a configuration...

+++ Sync

!!!success Works with any app
!!!

The following statement will copy and keep synced your picked `pagy*` file in your own `app/javascript` dir _(or any dir you may want use)_.

It will become and processed exactly like one of your own files.

```rb [pagy.rb initializer](/toolbox/configuration/initializer)
# Replace 'pagy*' with the file you picked
Pagy.sync(:javascript, Rails.root.join('app/javascript'), 'pagy*') if Rails.env.development?
```
==- Sync Task

If you prefer to sync manually or during an automation step, you can define your own task with a single line in the `Rakefile`, or any `*.rake` file:

```rb
# Pagy::SyncTask.new(resource, destination, *targets)
# Replace 'pagy*' with the file you picked
Pagy::SyncTask.new(:javascript, Rails.root.join('app/javascript'), 'pagy*')
```

and exec it with...

```sh
bundle exec rake pagy:sync:javascript
```
===

+++ Pipeline

!!!warning Works only with apps with an assets pipeline
!!!

```rb
Rails.application.config.assets.paths << Pagy::ROOT.join('javascripts')
```

+++

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
