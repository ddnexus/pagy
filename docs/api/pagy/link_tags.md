---
title: link_tags
icon: code-square
order: 100
categories:
  - Instance Methods
  - Tags
---

The `previous_link_tag` and `next_link_tag` conditionally return the previous/next page link tag. Useful to add the link tag to the HTML head.

```erb
<%== @pagy.previous_link_tag %>
<%== @pagy.next_link_tag %>
```
