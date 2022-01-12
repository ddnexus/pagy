# TypeScript source

This is the source dir that generates the the files in the `lib/javascripts` dir. 
  
## pagy.js

The `pagy.js` is meant to be loaded in your production pages. It is polyfilled for the `{"browserlist": [">0.25%", "not dead"}` and minified. Its size is ~2.9k 

You can generate custom targeted `pagy.js` files for the browsers you need by changing the `browserlist` query in
`src/package.json`, then compile it with `npm run build -w src`.

## pagy-dev.js

The `pagy-dev.js` is a readable javascript file meant to be used only for debugging with modern browsers. It won't work on old browser, so don't use it in production. It contains the source map data so you can debug the source TypeScript directly.

## pagy-module.js

The `pagy-module.js` is a ES6 module that exports the static `Pagy` object by default, only meant to be imported in other modules.

## pagy-module.d.ts

- The `pagy-module.d.ts` is the TypeScript Declaration File useful if you import the module in a TypeScript file.
