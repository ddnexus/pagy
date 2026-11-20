### Changes in 43.8.4

<!-- changes_start -->
- Restart the keynav pagination from the first of two empty pages
  - A visited page is shown empty only when no records follow it
  - The page shows the next records of the set, and the client forgets the visited pages after it
  - The clients that do not guard the updates keep their pages
- Handle the malformed params in the Request only
- Handle malformed page and limit params instead of raising (#939)
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)

Upgrading from version 9 or earlier? See the [Upgrade Guide](https://ddnexus.github.io/pagy/guides/upgrade-guide).

<!-- whats_new_start -->
<!-- whats_new_end -->
