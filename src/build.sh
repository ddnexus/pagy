#!/usr/bin/env bash

set -e

echo 'generating pagy-dev.js...'
tsc --alwaysStrict --target esnext --inlineSources --inlineSourceMap pagy.ts
mv -v pagy.js pagy-dev.js

echo 'generating pagy-module.d.ts and pagy-module.js...'
cp -v pagy.ts pagy-module.ts
echo 'export default Pagy;' >> pagy-module.ts
tsc --alwaysStrict --target esnext --declaration pagy-module.ts
rm -v pagy-module.ts

echo 'generating pagy.js from main.js'
parcel build   # nuke the distDir first

mv -vt ../lib/javascripts pagy-module.d.ts pagy-module.js pagy-dev.js
