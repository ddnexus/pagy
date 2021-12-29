# TypeScript source

This is the source dir that generates the `lib/javascripts/pagy.js` file. The source file `ts/src/pagy.ts` is compiled and 
minified in javascript through `babel`.

This dir encloses all the configuration files and `node_modules` dir needed for the task, keeping it all isolated from the `e2e`
environment.

The generated `pagy.js` is polyfilled with the `@babel/preset-env` `"useBuiltIns": "entry"`. You can generate a custom targeted javascript file for the browsers you need by changing that settings in package.json, then rebuild it with `cd ts && node run build:js`.
