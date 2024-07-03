### ✴ What's new in 8.0+ ✴

- New [Pagy Playground](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side (try the [pagy demo](https://ddnexus.github.io/pagy/playground.md#3-demo-app))
- New `:max_pages` variable to limit the pagination regardless the actual count
- Better frontend helpers
- The `foundation`, `materialize`, `semantic` and `uikit` CSS extras have been discontinued and will be removed in v9 (See the [details](https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328))
- Deprecate the legacy nav bar, add features to the default faster nav bar series
- See the [CHANGELOG](https://ddnexus.github.io/pagy/changelog) for possible breaking changes

### Changes in 8.6.3

<!-- changes start -->
- Add missing DEFAULT[:max_pages] hint to the config/pagy.rb
- Improve activerecord handling in playground apps
- Fix the missing "ar.pagy.aria_label.nav.other" (closes #577)
<!-- changes end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
