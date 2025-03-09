---
label: links_hash
icon: list-unordered
order: 180
categories:
  - Methods
  - Helpers
---

#

## :icon-list-unordered: links_hash

---

`links_hash` returns the `:first`, `:previous`, `:next`, `:last` non-`nil` URLs hash.

!!!success It works with all paginators
!!!

```ruby Controller
link_hash = @pagy.links_hash(**options)
```

==- Options

See [Common URL Options](../paginators.md#common-url-options)

===
