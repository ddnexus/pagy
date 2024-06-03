#!/usr/bin/env bash

set -e

js_path=../gem/javascripts

echo 'Generating pagy-module.js...'
bun build ./pagy.ts --target=node --no-bundle --outfile=$js_path/pagy-module.js

echo 'Generating pagy-dev.js. from dev.js..'
bun build ./main.js --target=browser --sourcemap=inline --outfile=$js_path/pagy-dev.js
sed -i "1,/var /{s/var /window./}" $js_path/pagy-dev.js

echo 'Generating pagy.js from min.js'
bun build ./main.js --target=browser --minify --outfile=$js_path/pagy.js
sed -i "0,/var ./{s/var ./window.Pagy/}" $js_path/pagy.js
