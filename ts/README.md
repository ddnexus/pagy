# TypeScript source

This is the source dir that generates the `lib/javascripts/pagy.js` file. The source file `ts/src/pagy.ts` is compiled and 
minified in javascript through `babel`.

The generated `pagy.js` is polyfilled with the `@babel/preset-env` `"useBuiltIns": "entry"`. You can generate a custom 
targeted javascript file for the browsers you need by changing that settings in package.json, then compile it with `npm run compile -w ts`.
