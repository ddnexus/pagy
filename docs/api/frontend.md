---
title: Pagy::Frontend
categories: 
- Core
- Module
---

# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. 

You will usually include it in some helper module, making its methods available (and overridable) in your views.

You can extend this module with a few more nav helpers _(see the [extras](/categories/extra) doc for more details)_

## Synopsis

```ruby View Helper
include Pagy::Frontend

# optional overriding of some sub-method
def pagy_nav(...)
   ...
end
```

```erb View
<%== pagy_nav(@pagy, **vars) %>
<%== pagy_info(@pagy, **vars) %>
```

## Methods

All the methods in this module are prefixed with the `"pagy_"` string in order to avoid any possible conflict with your own methods when you include the module in your helper. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden and not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need of monkey-patching or tricky gimmickry.

==- `pagy_nav(pagy, **vars)`

This method takes the Pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

```erb View
<%== pagy_nav(@pagy, **vars) %>
```

The method accepts also a few optional keyword arguments variables:

- `:id`: the `id` HTML attribute to the `nav` tag (omitted by default)
- `:aria_label`: an already pluralized string for the `aria-label` attribute of the `nav`, that will be used in place of 
  the default `pagy.aria_label.nav`
  defined) 
- `:size` which use the passed value instead of the `:size` variable of the instance

See also [ARIA Attributes](ARIA.md).

==- `pagy_info(pagy, **vars)`

This method provides the info about the content of the current pagination. For example:

```erb
<%== pagy_info(@pagy, **vars) %>
```

Will produce something like:

<span>Displaying items <b>476-500</b> of <b>1000</b> in total</span>

The method accepts also a few optional keyword arguments variables:

- `:id`: the `id` HTML attribute to the `span` tag wrapping the info
- `:item_name` an already pluralized string that will be used in place of the default `item/items`

```erb View
<%== pagy_info(@pagy, item_name: 'Product'.pluralize(@pagy.count)) %>
```

Displaying Products <b>476-500</b> of <b>1000</b> in total

_(see [Customizing the item name](/docs/how-to.md#customize-the-item-name))_

==- `pagy_url_for(pagy, page, absolute: false)`

This method is called internally in order to produce the url of a page by passing it its number. For standard usage it works out of the box and you can just ignore it.

See also [How to customize the URL](/docs/how-to.md#customize-the-url) and [How to customize the params](/docs/how-to.md#customize-the-params).

==- `pagy_anchor(pagy)`

This method is called internally to get a very specialized and fast proc that produce the HTML anchor elements (i.e. `a` tags) for the pages.

For standard usage you may just need to read [How to customize the link attributes](/docs/how-to.md#customize-the-link-attributes), for advanced usage see below.


### Advanced Usage

You need this section only if you are going to override a `pagy_nav*` helper AND you need to customize the HTML attributes of the
link tags.

!!! primary
This method is not intended to be overridden, however you could just replace it in your overridden `pagy_nav*` helpers with some
generic helper like the rails `link_to`. If you intend to do so, be sure to have a very good reason, since using `pagy_anchor` is
a lot faster than the rails `link_to` (benchmarked at ~22x faster using ~18x less memory on a 20 links nav).
!!!

This method returns a specialized proc that you call to produce the page `a` tags. The reason it is a two steps process instead of
a single method call is performance. Indeed the method calls the potentially expensive `pagy_url_for` only once and generates the
proc, then calling the proc will just interpolates the strings passed to it.

Here is how you should use it: in your helper call the method to get the proc (just once):

```ruby
a = pagy_anchor(pagy)
# or
a = pagy_anchor(pagy, anchor_string: 'verbatim string')
```

Then call the `a` proc to get the links (multiple times):

```ruby
my_link = a.(page_number, text, classes:, aria_label:)
```

#### The anchor_string argument

If you need to add some HTML attribute to ALL the page links, you can pass the `:anchor_string` keyword argument to any pagy 
helper, or if you use templates or override helpers, you can pass it also to the `pagy_anchor` method.

!!!warning Attributes Must be Valid HTML
For performance reasons, the `:anchor_string` string must be formatted as valid HTML attribute/value pairs because it will get 
inserted *verbatim* in the HTML of the `a` tag.
!!!

!!! warning Do Not Pass Attributes Already Present
Be careful not to pass some attribute that is already added by the helper. That would generate a duplicate HTML attribute which 
is invalid html (although handled by all mayor browsers by ignoring all the duplicates but the first).

!!!success Easily check the native component attributes:
```sh
pagy demo
# or: bundle exec pagy demo
# ...and point your browser at http://0.0.0.0:8000
```
!!!

==- `pagy_t(key, vars={})`

This method is similar to the `I18n.t` and its equivalent rails `t` helper. It is called internally from the helpers in order to 
get the interpolated strings out of a YAML dictionary file. _(see the [Pagy::I18n](i18n.md) doc for details)_

===
