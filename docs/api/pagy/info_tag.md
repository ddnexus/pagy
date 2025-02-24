---
title: info_tag
icon: code-square
order: 140
categories:
  - Instance Methods
  - Tags
---



==- `pagy_info(pagy, **opts)`

This method provides the info about the content of the current pagination. For example:

```erb
<%== @pagy.info_tag(**options) %>
```

Will produce something like:

<span>Displaying items <b>476-500</b> of <b>1000</b> in total</span>

The method accepts also a few optional keyword arguments options:

- `:id`: the `id` HTML attribute to the `span` tag wrapping the info
- `:item_name` an already pluralized string that will be used in place of the default `item/items`

```erb View
<%== pagy_info(@pagy, item_name: 'Product'.pluralize(@pagy.count)) %>
```

Displaying Products <b>476-500</b> of <b>1000</b> in total

_(see [Customizing the item name](/docs/Practical%20Guide/how-to.md#customize-the-item-name))_
