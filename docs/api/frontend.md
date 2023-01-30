---
title: Pagy::Frontend
categories: 
- Core
- Module
---

# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. 

You will usually include it in some helper module, making its methods available (and overridable) in your views. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb))_

You can extend this module with a few more nav helpers _(see the [extras](/categories/extra) doc for more details)_

## Synopsis

||| View Helper
```ruby
include Pagy::Frontend

# optional overriding of some sub-method
def pagy_nav(...)
   ...
end
```
|||

||| View

```erb
<%== pagy_nav(@pagy, ...) %>
<%== pagy_info(@pagy, ...) %>
```
|||

## Methods

All the methods in this module are prefixed with the `"pagy_"` string in order to avoid any possible conflict with your own methods when you include the module in your helper. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden and not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need of monkey-patching or tricky gimmickry.

==- `pagy_nav(pagy, ...)`

This method takes the Pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

||| View
```erb
<%== pagy_nav(@pagy, ...) %>
```
|||

The method accepts also a few optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attribute to the `nav` tag
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)
- `:size` which use the passed size Array instead of the `:size` variable of the instance

The `nav.*` templates produce the same output, and can be used as an easier (but slower) way to customize it.

See also [Using templates](/docs/how-to.md#use-templates).

==- `pagy_info(pagy, pagy_id: ..., item_name: ..., i18n_key: ...)`

This method provides the info about the content of the current pagination. For example:

```erb
<%== pagy_info(@pagy, ...) %>
```

Will produce something like:

<span>Displaying items <b>476-500</b> of <b>1000</b> in total</span>

The method accepts also a few optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attribute to the `span` tag wrapping the info
- `:item_name` an already pluralized string that will be used in place of the default `item/items`
- `:i18n_key` the key to lookup in a dictionary

Notice the `:i18n_key` can be passed also to the constructor or be a less useful global variable (i.e. `Pagy::DEFAULT[:i18n_key]`

||| View
```erb
<%== pagy_info(@pagy, item_name: 'Product'.pluralize(@pagy.count) %>
<%== pagy_info(@pagy, i18n_key: 'activerecord.model.product' %>
```
|||

Displaying Products <b>476-500</b> of <b>1000</b> in total

_(see [Customizing the item name](/docs/how-to.md#customize-the-item-name))_

==- `pagy_url_for(pagy, page, absolute: false, html_escaped: false)`

This method is called internally in order to produce the url of a page by passing it its number. For standard usage it works out of the box and you can just ignore it.

See also [How to customize the URL](/docs/how-to.md#customize-the-url) and [How to customize the params](/docs/how-to.md#customize-the-params).

==- `pagy_link_proc(pagy, link_extra='')`

This method is called internally to get a very specialized and fast proc that produce the HTML links for the pages.

For standard usage you may just need to read [How to customize the link attributes](/docs/how-to.md#customize-the-link-attributes), for advanced usage see below.

===

## Advanced Usage

You need this section only if you are going to override a `pagy_nav*` helper or a template AND you need to customize the HTML attributes of the link tags.

!!! primary
This method is not intended to be overridden, however you could just replace it in your overridden `pagy_nav*` helpers or templates with some generic helper like the rails `link_to`. If you intend to do so, be sure to have a very good reason, since using `pagy_link_proc` is a lot faster than the rails `link_to` (benchmarked at ~22x faster using ~18x less memory on a 20 links nav).
!!!

This method returns a specialized proc that you call to produce the page links. The reason it is a two steps process instead of a single method call is performance. Indeed the method calls the potentially expensive `pagy_url_for` only once and generates the proc, then calling the proc will just interpolates the strings passed to it.

Here is how you should use it: in your helper or template call the method to get the proc (just once):

```ruby
link = pagy_link_proc( pagy [, extra_attributes_string ] )
```

Then call the `"link"` proc to get the links (multiple times):

```ruby
link.call( page_number [, text [, extra_attributes_string ] ] )
```

### Extra attribute strings

If you need to add some HTML attribute to the page links, you can pass some extra attribute string at many levels, depending on the scope you want your attributes to be added.

!!!primary Attributes Must be Valid HTML
For performance reasons, the extra attributes strings must be formatted as valid HTML attribute/value pairs. _All_ the strings passed at any level will get inserted *verbatim* in the HTML of the link.
!!!

1. For all pagy objects: set the global variable `:link_extra`:

    ||| pagy.rb (initializer)
    ```ruby
    Pagy::DEFAULT[:link_extra] = 'data-remote="true"'
    |||

    ||| View
    ```ruby
    link = pagy_link_proc(pagy)
    link.call(2)
    #=> <a href="...?page=2" data-remote="true">2</a>
    ```
    |||

2. For one Pagy object: pass the `:link_extra` variable to a Pagy constructor (`Pagy.new` or `pagy` controller method):

    ||| Controller
    ```ruby
    @pagy, @records = pagy(my_scope, link_extra: 'data-remote="true"')
    ```
    |||

    ||| View
    ```ruby
    link = pagy_link_proc(pagy)
    link.call(2)
    #=> <a href="...?page=2" data-remote="true">2</a>
    ```

3. For all the `link.call`: pass an extra attributes string to the `pagy_link_proc`:

    ||| View
    ```ruby
    link = pagy_link_proc(pagy, 'class="page-link"')
    link.call(2)
    #=> <a href="...?page=2" data-remote="true" class="page-link">2</a>
    link.call(3)
    #=> <a href="...?page=3" data-remote="true" class="page-link">3</a>
    ```
    |||

4. For a single `link.call`: pass an extra attributes string when you call the proc:

    ||| View
    ```ruby
    link.call(page_number, 'aria-label="my-label"')
    #=> <a href="...?page=2" data-remote="true" class="page-link" aria-label="my-label">2</a>
    ```
    |||

#### CAVEATS

We use only strings for performance, so the attribute strings get concatenated level after level, but not merged!

!!! warning Do Not Pass Atributes Multiple Times
Be careful not to pass the same attribute at different levels multiple times. That would generate a duplicated HTML attribute which is illegal html (although handled by all mayor browsers by ignoring all the duplicates but the first).
!!!

!!!warning Do not add `class` attribute for `*js` helpers
Specifically do not add a `class` attribute that will end up in the `pagy_bootstrap_nav_js`, `pagy_semantic_nav_js` and `pagy_semantic_combo_nav_js`, which define already their own.
!!!

==- `pagy_t(key, vars={})`

This method is similar to the `I18n.t` and its equivalent rails `t` helper. It is called internally (from helpers and templates) in order to get the interpolated strings out of a YAML dictionary file. _(see the [Pagy::I18n](i18n.md) doc for details)_

===

