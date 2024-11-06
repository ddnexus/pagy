<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations  
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->

### Changes in 9.2.0

<!-- changes_start -->
- Simplify the keyset API:
  - Deprecate the :after_latest variable in favour of :filter_newest
  - Add the keyset argument to the :filter_newest lambda
  - Rename protected after_latest_query > filter_newest_query
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
