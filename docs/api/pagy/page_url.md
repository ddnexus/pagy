---
title: page_url
icon: arrow-right
order: 175
categories:
  - Instance Methods
  - Helpers
---

`pagy_links_hash` returns the `:first`, `:previous`, `:next`, `:last` non`nil` URLs hash.

It respects `jsonapi: true` if passed with `@pagy`.

```ruby Controller
link_hash = pagy_links_hash(@pagy, **options)
```

=== Options

- `absolute: true` 
  - URL absolute
- `fragment: '#...'`
  - URL fragment string

===
