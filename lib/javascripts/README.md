# Generated Javascript Files

The following files are generated from the files in the `src` dir for different Javascript/TypeScript [Environments](#environments). 

## Files

These files are all providing the `Pagy` object and its only function `init`. You can get their absolute path from ruby with: `Pagy.root.join('javascripts', '......')`.

### pagy-module.js

The [`pagy-module.js`](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-module.js) is a ES6 module to use with webpacker, esbuild, parcel, etc. Import it with `import Pagy from "pagy-module"`.
 
<details>

<summary>pagy-module.d.ts </summary>

The `pagy-module.d.ts` is the small TypeScript Declaration File useful only if you import the `pagy-module.js` in a TypeScript file.

</details>

### pagy.js

The `pagy.js` is a drop-in script meant to be loaded as is, directly in your production pages and without any further processing. It is an IIFE file, already minified (~2.9k) and polyfilled to work also with quite old browsers.

<details>

<summary>Default supported browserslist...</summary>

- and_chr 96
- and_ff 95
- and_qq 10.4
- and_uc 12.12
- android 96
- baidu 7.12
- chrome 97
- chrome 96
- chrome 95
- chrome 94
- edge 97
- edge 96
- firefox 96
- firefox 95
- firefox 94
- firefox 91
- firefox 78
- ie 11
- ios_saf 15.2
- ios_saf 15.0-15.1
- ios_saf 14.5-14.8
- ios_saf 14.0-14.4
- ios_saf 12.2-12.5
- kaios 2.5
- op_mini all
- op_mob 64
- opera 82
- opera 81
- safari 15.2
- safari 15.1
- safari 14.1
- safari 13.1
- samsung 15.0
- samsung 14.0

**Notice**: You can generate custom targeted `pagy.js` files for the browsers you want to support by changing the [browserslist](https://github.com/browserslist/browserslist) query in `src/package.json`, then compile it with `npm run build -w src`.

</details>

<details>

<summary>pagy-dev.js (pagy debug only)</summary>

The [`pagy-dev.js`](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy-dev.js) is a readable javascript file meant to be used as a drop-in file **only for debugging** with modern browsers. It won't work on old browsers and its size is big because it contains also the source map data to debug the TypeScript directly. Obviously... do not use it in production.

</details>

## Environments

### Non-rails apps / simple apps

Add an event listener that fires on page load:

```js
window.addEventListener('load', Pagy.init);
```

Ensure the `Pagy.root.join('javascripts', 'pagy.js')` script gets served with the page.


### Rails Apps

Trouble-shooting your javascript installation on Rails? Some [of these rails demo apps](https://github.com/stars/benkoshy/lists/rails-demo-apps-for-pagy) may help (the commit diffs are structured to make it elementary).

#### 1. Rails asset pipeline

##### Sprockets

In `application.js`, require pagy and add an event listener like `"turbolinks:load"` or `"load"` that fires on page load:

```js
//= require pagy
window.addEventListener(YOUR_EVENT_LISTENER, Pagy.init);
```

Or you can do so using Stimulus JS:

```js
// pagy_initializer_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    Pagy.init(this.element)
  }
}
```

```html+erb
<div data-controller="pagy-initializer">
  <%== pagy_nav_js(@pagy) %>
</div>
```

Uncomment the following line in `config/initializers/pagy.rb`:

```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```
##### Propshaft

```ruby
# config/initializers/pagy.rb
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```

```erb
<-- e.g. appliciation.html.erb -->
<%= javascript_include_tag "pagy" %>
```

And initialize Pagy any way you like (as above).

#### 2. Rails jsbundling-rails

In `app/javascript/application.js`, import and use the pagy module: 

```js
// or use stimulus JS above
import Pagy from "pagy-module";
window.addEventListener("turbo:load", Pagy.init);
```

**IMPORTANT**: Pagy doesn't push any package to `npm`, because there would be no automatic way to keep the package version in sync with the gem version used by your app. Doing it manually at every `yarn update` and every `bundle update` would be quite annoying and error prone for you. 

Luckily, you can just configure your javascript tools to look into the `$(bundle show 'pagy')/lib/javascripts` gem installation path once, and pagy will work maintenance-free from then on.

Here is how to do that with different bundlers:

##### Esbuild

In `package.json`, prepend the `NODE_PATH` environment variable to the `scripts.build` command:

```json
{
  "build": "NODE_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your original command>"
}
```

##### Webpack

In `package.json`, prepend the `PAGY_PATH` environment variable to the `scripts.build` command:

```json
{
  "build": "PAGY_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your webpack command>"
}
```

In `webpack.confg.js`, add the `resolve.modules` array:

```js
module.exports = {
  ...,                          // your original config
  resolve: {                    // add resolve.modules
    modules: [
      "node_modules",           // node_modules dir
      process.env.PAGY_PATH     // pagy dir
    ]
  }
}
```

##### Rollup

In `package.json`, prepend the `PAGY_PATH` environment variable to the `scripts.build` command:

```json
{
  "build": "PAGY_PATH=\"$(bundle show 'pagy')/lib/javascripts\" <your rollup command>"
}
```

In `rollup.confg.js`, configure the `plugins[resolve]`:

```js
export default {
  ...,                                    // your original config
  plugins: [
    resolve({
              moduleDirectories: [        // add moduleDirectories
                "node_modules",           // node_modules dir
                process.env.PAGY_PATH     // pagy dir
              ] 
    })
  ]
}
```

#### Rails Importmap

In `app/javascript/application.js`, import and use the pagy module:

```js
// or use stimulus JS above
import Pagy from "pagy-module";
window.addEventListener("turbo:load", Pagy.init);
```

Uncomment the following line in `config/initializers/pagy.rb` initializer:

```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```

Link `pagy-module.js` in `app/assets/config/manifest.js`:

```js
//= link pagy-module.js
```

Pin the pagy-module in `config/importmap.rb`:

```ruby
pin 'pagy-module'
```

### Other environments/methods

Here are other ways to load the pagy javascript files from your app if the above methods don't work for you:

#### Symlink file

You can create a symlink of any pagy javascript file and use it as it was a local file in your app.

For example, adding the following line in `config/initializers/pagy.rb` will create/refresh the `app/javascript/pagy-module.js` symlink every time the app restarts.

```ruby
FileUtils.ln_sf(Pagy.root.join('javascripts', 'pagy-module.js'), Rails.root.join('app', 'javascript')) \
  unless Rails.env.production? 
```

#### Rails Webpacker (legacy)

This was a legacy way to generate a local pagy javascript file using `erb` with webpacker. If the methods explained above don't work, this one should.

Ensure that the `erb` loader is installed:

```sh
bundle exec rails webpacker:install:erb
```

Create `app/javascript/packs/pagy.js.erb` with the following content:

```erb
<%= Pagy.root.join('javascripts', 'pagy.js').read %>
window.addEventListener(YOUR_EVENT_LISTENER, Pagy.init)
```

where YOUR_EVENT_LISTENER is the load event that works with your app (e.g. `"turbo:load"`, `"turbolinks:load"`, `"load"`, ...).

Import it in `app/javascript/application.js`:

```js
import './pagy.js.erb'
```
