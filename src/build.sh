#!/usr/bin/env bash

set -e

js_path=../gem/javascripts

echo 'Generating javascript files'
bun build ./pagy.ts --target=node --no-bundle --outfile=$js_path/pagy.mjs

bun build ./pagy.min.js --target=browser --minify --sourcemap=external --outdir=$js_path
sed -i "0,/var ./{s/var ./window.Pagy/}" $js_path/pagy.min.js
# fix the bun issue https://github.com/oven-sh/bun/issues/3325
echo "//# sourceMappingURL=pagy.min.js.map" >> $js_path/pagy.min.js

# Copy the deprecated files that can break a production app
cd $js_path
cp pagy.min.js pagy.js
cp pagy.mjs pagy-module.js
