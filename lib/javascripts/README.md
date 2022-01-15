# Generated Javascript

The following files are generated from the files in the `src` dir for different Javascript/TypeScript usage.

## pagy.js

The `pagy.js` is meant to be loaded in your production pages. It is polyfilled for quite old browser and minified. Its size is ~2.9k.

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

**Notice**: You can generate custom targeted `pagy.js` files for the browsers you want to support by changing the [browserslist](https://github.com/browserslist/browserslist) query in
`src/package.json`, then compile it with `npm run build -w src`.
 
Its path from your code is: `Pagy.root.join('javascript', 'pagy.js')`

## pagy-dev.js

The `pagy-dev.js` is a readable javascript file meant to be used only for debugging with modern browsers. It won't work on old browser, so don't use it in production. It contains the source map data so you can debug the source TypeScript directly.

Its path from your code is: `Pagy.root.join('javascript', 'pagy-dev.js')`

## pagy-module.js

The `pagy-module.js` is a ES6 module that exports the static `Pagy` object by default, only meant to be imported in other modules.

Its path from your code is: `Pagy.root.join('javascript', 'pagy-mdule.js')`

## pagy-module.d.ts

The `pagy-module.d.ts` is the TypeScript Declaration File useful if you import the module in a TypeScript file.

Its path from your code is: `Pagy.root.join('javascript', 'pagy-module.d.ts')`
