<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations  
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->

### Changes in 9.0.3

<!-- changes_start -->
- Remove legacy and unused javascript files
- Improve pagy_get_page with force_integer option
- Fix jsonapi with keyset
- Complete the internal refactoring of version 9:
  - Remove the pagy*_get_vars methods now useless
  - Use to_i on the page variable for the search extras
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
