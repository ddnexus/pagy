#

## :icon-code-square:&nbsp;&nbsp;anchor_tags

---

:::raised
![](/assets/images/pagy-anchor_tags.png){width=73}
:::
<br/>

:::content-center
[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy demo`"](/sandbox/playground/#demo)
:::

The `previous_tag` and `next_tag` return the enabled/disabled previous/next page anchor tag.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `:countless`, `:keyset` paginators).

!!!success `next_tag` works with all paginators
!!!

!!!warning `previous_tag` works with all paginators but `:keyset`
!!!

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

`absolute: true`
: Makes the URL absolute.

`path: '/my_path'`
: Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](/guides/how-to#paginate-multiple-independent-collections))_

`fragment: '...'`
: URL fragment string.

`querify: tweak`
: Set it to a `Lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
  ```ruby
  tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

===
