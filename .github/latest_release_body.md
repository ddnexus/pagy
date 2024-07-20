<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations  
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->

### Changes in 9.0.2

<!-- changes_start -->
- Rename and document the link header to pagy_link_header
- Add first and next url helpers to the keyset extra; add the keyset section to config/pagy.rb
- Fix nil page in keyset URL not overriding the params page
- Extracted shared method
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
