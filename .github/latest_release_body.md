## ⚠ WARNING

We may drop pagy's less used CSS extras.

If you wish to keep your favorites alive, please, [vote here](https://github.com/ddnexus/pagy/discussions/categories/survey)

### ✴ What's new in 8.+ ✴

- Better frontend helpers
- New [Pagy Playground](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on
  your side (try the [pagy demo](https://ddnexus.github.io/pagy/playground.md#3-demo-app))
- See the [CHANGELOG](https://ddnexus.github.io/pagy/changelog) for possible breaking changes

### Changes in 8.0.2

<!-- changes start -->
- Minor change in rails app and RM run config
- Fix canonical gem root:
  - Correct script.build: "NODE_PATH=\"$(bundle show 'pagy')/javascripts\"
  - Move pagy.gemspec inside the gem root dir
- Fix for Turbo not intercepting changes in window.location
- Use require_relative for gem/lib files
- Complete translation of aria.nav for "ru" locale (close #599)
- Docs improvement and fixes
<!-- changes end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
