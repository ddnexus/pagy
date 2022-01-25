# Generated Javascript Files

The following files are generated from the files in the `src` dir for different Javascript/TypeScript usage. They are all providing the `Pagy` object and its only function `init`, but they are meant to be used in different app environments: e.g. served as is (for simple apps), or processed and included in a javascript bundle.

You can get their absolute path from ruby with: `Pagy.root.join('javascripts', '......')`.

## Files

### pagy.js

The `pagy.js` is a drop-in file meant to be loaded as is, directly in your production pages and without any further processing. It is an IIFE file, already polyfilled to work also with quite old browsers and minified (~2.9k).

<details>

<summary>Here is the default supported browserslist</summary>

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

</details>

**Notice**: You can generate custom targeted `pagy.js` files for the browsers you want to support by changing the [browserslist](https://github.com/browserslist/browserslist) query in `src/package.json`, then compile it with `npm run build -w src`.

### pagy-dev.js

The `pagy-dev.js` is a readable javascript file meant to be used as a drop-in file **only for debugging** with modern browsers. It won't work on old browsers and its size is big because it contains also the source map data to debug the TypeScript directly. Obviously... do not use it in production.

### pagy-module.js

The `pagy-module.js` is a ES6 module that exports the `Pagy` object by default, it's only meant to be imported in other modules or into an entry point and needs post processing (polyfilling, minification, bundling, ...). It makes sense when your app use something like webpacker, esbuild, parcel, etc.

You import it with `import Pagy from "pagy-module"`

### pagy-module.d.ts

The `pagy-module.d.ts` is the small TypeScript Declaration File useful only if you import the `pagy-module.js` in a TypeScript file.

## Environments

### Non-rails apps / simple apps

Ensure the `Pagy.root.join('javascripts', 'pagy.js')` script gets served with the page.

Add an event listener that fires on page load:

```js
window.addEventListener('load', Pagy.init);
```

### Rails asset pipeline

If your app uses the sprocket asset-pipeline, uncomment the following line in the `pagy.rb` initializer:

```ruby
Rails.application.config.assets.paths << Pagy.root.join('javascripts')
```

Add the pagy javascript to the `application.js`:

```js
//= require pagy
```

Add an event listener like `"turbolinks:load"` or `"load"` that fires on page load:

```js
window.addEventListener(YOUR_EVENT_LISTENER, Pagy.init);
```

### Rails Webpacker (legacy)

If your app uses webpacker, ensure that the `erb` loader is installed:

```sh
bundle exec rails webpacker:install:erb
```

Then create a `app/javascript/packs/pagy.js.erb` with the following content:

```erb
<%= Pagy.root.join('javascripts', 'pagy.js').read %>

window.addEventListener(YOUR_EVENT_LISTENER, Pagy.init)
```

where YOUR_EVENT_LISTENER is `"turbo:load"`, `"turbolinks:load"` or `"load"`, and import it in `app/javascript/application.js`:

```js
import './pagy.js.erb'
```

### Rails jsbuilding-rails / esbuild

In order to allow `esbuild` to find any pagy javascript file, you should set the `NODE_PATH` environment variable to the `Pagy.root.join('javascripts')` dir, prepending it to your `package.json` `scripts.build`:

```json
{
    "build": "NODE_PATH=$(bundle exec ruby -e \"puts Pagy.root.join('javascripts')\") <your original script>"
}
```

Then use any pagy file as you like. For example import and use the pagy module in the `app/javascript/application.js`:

```js
import Pagy from "pagy-module"
window.addEventListener("turbo:load", Pagy.init);
```
