---
label: anchor_tags
icon: code-square
order: 140
image: ""
categories:
  - Methods
  - Tags
---

#

## :icon-code-square: anchor_tags

---

:::raised
![](../../assets/images/pagy-anchor_tags.png){width=73}
:::
<br/>

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

The `previous_tag` and `next_tag` return the enabled/disabled previous/next page anchor tag.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `:countless`, `:keyset` paginators).

!!!warning `previous_tag` works with all paginators but `:keyset`
!!!

!!!success `next_tag` works with all paginators
!!!

```erb
<%== @pagy.previous_tag %>
<%== @pagy.next_tag %>
```

==- Examples

```ruby
>> puts @pagy.previous_tag
<a href="/path?example=123&page=2" aria-label="Previous">&lt;</a>
=> nil

>> puts @pagy.next_tag
<a href="/path?example=123&page=4" aria-label="Next">&gt;</a>
=> nil

>> puts @pagy.next_tag(text: 'Show Next', aria_label: 'my-next')
<a href="/path?example=123&page=4" aria-label="my-next">Show Next</a>
=> nil
```

==- Options

- `text: 'My Page'`
  - Override the default generated page label
- `aria_label: 'My Link'`
  - Override the default aria label string looked up in the dictionary

See also [Common URL Options](../paginators#common-url-options)

===
