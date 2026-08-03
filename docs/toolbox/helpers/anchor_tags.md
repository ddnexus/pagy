---
label: anchor_tags
icon: code-square
order: 140
image: ""
---

#

## :icon-code-square:&nbsp;&nbsp;anchor_tags

---

:::raised
![](/assets/images/pagy-anchor_tags.png){width=73}
:::
<br/>

:::content-center
{{ include "snippets/run-app" app: "demo" }}
:::

The `previous_tag` and `next_tag` return the enabled/disabled previous/next page anchor tag.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `:countless`, `:keyset` paginators).

!!!success
`next_tag` works with all paginators
!!!

{{ include "snippets/all-but-keyset" what: "`previous_tag`" }}

=== :icon-tools:&nbsp; Usage

```erb
<%== @pagy.next_tag %>
<%== @pagy.previous_tag %>
```

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

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

==- :icon-sliders:&nbsp; Options

`text: 'My Page'`
: Override the default text _(instead of looking up the `pagy.previous`/`pagy.next` entry in the dictionary)_

`aria_label: 'My Link'`
: Override the default aria label _(instead of looking up the `pagy.aria_label.previous`/`pagy.aria_label.next` entry in the dictionary)_


{{ include "options/helper-url" }}

===
