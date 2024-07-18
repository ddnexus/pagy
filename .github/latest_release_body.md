<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->

### Changes in 9.0.0

<!-- changes_start -->
- Improve Keyset::Sequel and docs
- BREAKING: Rename :max_limit > :limit_max
- BREAKING: Rename variable, param, accessor, extra and helper "items" to "limit"
- Add playground keyset_ar.ru and keyset_s.ru apps and integration with the rest of the gems
- Add keyset pagination base files
  - Pagy::Keyset API
  - ActiveRecord and Sequel adapters
- BREAKING: Transform the vars positional hash argument in keyword arguments (double splat); internal renaming of setup/assign methods
- Refactor pagy_get_vars in various backend extras
- BREAKING: Refactor the fragment url
- BREAKING: Refactor the anchor_string system
- BREAKING: Drop the support for 8+ deprecations
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
