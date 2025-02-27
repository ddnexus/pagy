---
title: links_hash
icon: list-unordered
order: 180
categories:
  - Methods
  - Helpers
---

`pagy_links_hash` returns the `:first`, `:previous`, `:next`, `:last` non-`nil` URLs hash.

It respects `jsonapi: true`.

```ruby Controller
link_hash = pagy_links_hash(@pagy, **options)
```

==- Options

See [Common URL Options](../instance.md#common-url-options)

===
