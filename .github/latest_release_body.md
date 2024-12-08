<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations  
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->

### Changes in 9.3.3

<!-- changes_start -->
- Add test for locales - to find problematic keys (#752)
- Update locales: zh-CN, zh-HK, zh-TW  (#751) (fix #608, fix #609, fix #610)
  - Remove :other from :aria_label key and code comment
  - Change :item_name which had :one_other keys to default to the :other key
  - Fix comment
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
