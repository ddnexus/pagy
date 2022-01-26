#!/usr/bin/env bash

set -e

cleanup() {
    echo "cleaning up artifacts..."
    rm -f pagy-module.d.ts pagy-module.ts pagy-module.js pagy-dev.js pagy.js
}
trap cleanup EXIT

echo 'generating pagy-dev.js...'
tsc --alwaysStrict --target esnext --inlineSources --inlineSourceMap pagy.ts
mv -v pagy.js pagy-dev.js
sed -i "0,/const Pagy =/{s/const Pagy =/window.Pagy =/}" pagy-dev.js

echo 'generating pagy-module.d.ts and pagy-module.js...'
cp -v pagy.ts pagy-module.ts
echo 'export default Pagy;' >> pagy-module.ts
tsc --alwaysStrict --target esnext --declaration pagy-module.ts

echo 'generating pagy.js from main.js'
parcel build --cache-dir .parcel-cache

mv -vt ../lib/javascripts pagy-module.d.ts pagy-module.js pagy-dev.js
