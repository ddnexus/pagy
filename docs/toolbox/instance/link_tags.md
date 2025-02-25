---
title: link_tags
icon: code-square
order: 100
categories:
  - Methods
  - Tags
---

The `previous_link_tag` and `next_link_tag` conditionally return the previous/next page link tag. Useful to add the link tag to the HTML head.

```erb
<%== @pagy.previous_link_tag %>
<%== @pagy.next_link_tag %>
```

Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.previous_link_tag
<link href="/path?example=123&page=2"/>
=> nil
>> puts @pagy.next_link_tag
<link href="/path?example=123&page=4"/>
=> nil
```
