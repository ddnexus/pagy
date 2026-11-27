### Changes in 43.8.8

<!-- changes_start -->
- Remove redundant to_s in calendar.rb
- Drop the offset page param from the calendar links in every setup
  - The links kept it with the page_key set in the Pagy::OPTIONS, with a root_key, and with jsonapi and a custom page_key
  - The unit page params keep their names
- Drop the offset page param from the calendar url_at (#944)
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)

Upgrading from version 9 or earlier? See the [Upgrade Guide](https://ddnexus.github.io/pagy/guides/upgrade-guide).

<!-- whats_new_start -->
<!-- whats_new_end -->
