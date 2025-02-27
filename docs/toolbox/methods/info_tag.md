---
title: info_tag
icon: code-square
order: 140
categories:
  - Methods
  - Tags
---



`info_tag` provides the info about the content of the current pagination. For example:

```erb
<%== @pagy.info_tag(**options) %>
```

Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.info_tag
<span class="pagy info">Displaying items 41-60 of 1000 in total</span>
=> nil

>> puts @pagy.info_tag(id: 'the-info-tag', item_name: 'Products')
<span id="the-info-tag" class="pagy info">Displaying Products 41-60 of 1000 in total</span>
=> nil
```

==- Options

The method accepts also a few optional keyword arguments options:

- `id: 'my-info'`
  - The `id` HTML attribute to the `span` tag wrapping the info.
- `item_name: 'Products` 
  - The already pluralized string that will be used in place of the default `item/items`

===
