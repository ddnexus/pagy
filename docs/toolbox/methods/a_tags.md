---
title: a_tags
icon: code-square
order: 110
categories:
  - Methods
  - Tags
---

The `previous_a_tag` and `next_a_tag` return the enabled/disabled previous/next page anchor tag.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `:countless`, `:keyset` paginators).

```erb
<%== @pagy.previous_a_tag %>
<%== @pagy.next_a_tag %>
```

Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.previous_a_tag
<a href="/path?example=123&page=2" aria-label="Previous">&lt;</a>
=> nil

>> puts @pagy.next_a_tag
<a href="/path?example=123&page=4" aria-label="Next">&gt;</a>
=> nil

>> puts @pagy.next_a_tag(text: 'show me', aria_label: 'my-next')
<a href="/path?example=123&page=4" aria-label="my-next">show me</a>
=> nil
```

==- Options

- `text: 'My Page'`
  - Override the default generated page label
- `aria_label: 'My Link'`
  - Override the default aria label string looked up in the dictionary

See also [Common URL Options](../methods#common-url-options)

===
