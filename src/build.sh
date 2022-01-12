#!/usr/bin/env bash

set -e

echo 'generating pagy-dev.js...'
tsc --inlineSources --inlineSourceMap
mv pagy.js pagy-dev.js

echo 'generating pagy-module.d.ts and pagy-module.js...'
cp pagy.ts pagy-module.ts

echo 'export default Pagy;' >> pagy-module.ts
tsc --target esnext --declaration  pagy-module.ts

header="/* Generated from 'src/pagy.ts' with TypeScript $(tsc -v) */"
sed -i "1i$header" pagy-dev.js pagy-module.js
echo "added header: \"$header\""

echo 'generating pagy.js'
parcel build

mv -t ../lib/javascripts pagy-module.d.ts pagy-module.js pagy-dev.js
rm pagy-module.ts
