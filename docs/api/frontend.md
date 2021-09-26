---
title: Pagy::Frontend
---

# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. You will usually include it in some helper module, making its methods available (and overridable) in your views. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb))_

You can extend this module with a few more nav helpers _(see the [extras](../extras.md) doc for more details)_

## Synopsis

```ruby
# typically in some helper
include Pagy::Frontend

# optional overriding of some sub-method (e.g. massage the params)
def pagy_massage_params(params)
  params.except(:anything, :not, :useful).merge!(something: 'more useful')
end
```

use some of its method in some view:

```erb
<%== pagy_nav(@pagy, ...) %>
<%== pagy_info(@pagy, ...) %>
```

## Methods

All the methods in this module are prefixed with the `"pagy_"` string in order to avoid any possible conflict with your own methods when you include the module in your helper. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden and not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need of monkey-patching or tricky gimmickry.

### pagy_nav(pagy, ...)

This method takes the Pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

```erb
<%== pagy_nav(@pagy, ...) %>
```

The method accepts also a couple of optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attributed to the `nav` tag
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)

The `nav.*` templates produce the same output, and can be used as an easier (but slower) way to customize it.

See also [Using templates](../how-to.md#using-templates).

### pagy_info(pagy, pagy_id: ..., item_name: ..., i18n_key: ...)

This method provides the info about the content of the current pagination. For example:

```erb
<%== pagy_info(@pagy, ...) %>
```

Will produce something like:

<span>Displaying items <b>476-500</b> of <b>1000</b> in total</span>

The method accepts also a few optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attributed to the `span` tag wrapping the info
- `:item_name` an already pluralized string that will be used in place of the default `item/items`
- `:i18n_key` the key to lookup in a dictionary

Notice the `:i18n_key` can be passed also to the constructor or be a less useful global variable (i.e. `Pagy::DEFAULT[:i18n_key]`

```erb
<%== pagy_info(@pagy, item_name: 'Product'.pluralize(@pagy.count) %>
<%== pagy_info(@pagy, i18n_key: 'activerecord.model.product' %>
```

Displaying Products <b>476-500</b> of <b>1000</b> in total

_(see [Customizing the item name](../how-to.md#customizing-the-item-name))_

### pagy_url_for(pagy, page, absolute: nil)

This method is called internally in order to produce the url of a page by passing it its number. For standard usage it works out of the box and you can just ignore it.

For more advanced usage, you may want to override it in order to fit its behavior with your app needs (e.g.: allowing fancy routes, etc.).

Notice: If you just need to remove or add some param, you may prefer to override the `pagy_massage_params` method instead.

See also [Customizing the URL](../how-to.md#customizing-the-url).

### pagy_massage_params(params)

Sub-method called by `pagy_url_for`: it is intended to be overridden when you need to add and/or remove some param from the page URLs. It receives the `params` hash complete with the `"page"` param and should return a possibly modified version of it.

See also [Customizing the params](../how-to.md#customizing-the-params).

### pagy_link_proc(pagy, link_extra='')

This method is called internally to get a very specialized and fast proc that produce the HTML links for the pages.

For standard usage you may just need to read [Customizing the link attributes](../how-to.md#customizing-the-link-attributes), for advanced usage see below.

## Advanced Usage

You need this section only if you are going to override a `pagy_nav*` helper or a template AND you need to customize the HTML attributes of the link tags.

**Important**: This method is not intended to be overridden, however you could just replace it in your overridden `pagy_nav*` helpers or templates with some generic helper like the rails `link_to`. If you intend to do so, be sure to have a very good reason, since using `pagy_link_proc` is a lot faster than the rails `link_to` (benchmarked at ~22x faster using ~18x less memory on a 20 links nav).

This method returns a specialized proc that you call to produce the page links. The reason it is a two steps process instead of a single method call is performance. Indeed the method calls the potentially expensive `pagy_url_for` only once and generates the proc, then calling the proc will just interpolates the strings passed to it.

Here is how you should use it: in your helper or template call the method to get the proc (just once):

```rb
link = pagy_link_proc( pagy [, extra_attributes_string ] )
```

Then call the `"link"` proc to get the links (multiple times):

```rb
link.call( page_number [, text [, extra_attributes_string ] ] )
```

### Extra attribute strings

If you need to add some HTML attribute to the page links, you can pass some extra attribute string at many levels, depending on the scope you want your attributes to be added.

**Important**: For performance reasons, the extra attributes strings must be formatted as valid HTML attribute/value pairs. _All_ the strings passed at any level will get inserted verbatim in the HTML of the link.

1. For all pagy objects: set the global variable `:link_extra`:

    ```rb
    # in the pagy.rb initializer file
    Pagy::DEFAULT[:link_extra] = 'data-remote="true"'
    # in any view
    link = pagy_link_proc(pagy)
    link.call(2)
    #=> <a href="...?page=2" data-remote="true">2</a>
    ```

2. For one Pagy object: pass the `:link_extra` variable to a Pagy constructor (`Pagy.new` or `pagy` controller method):

    ```ruby
    # in any controller
    @pagy, @records = pagy(my_scope, link_extra: 'data-remote="true"')
    # in any view
    link = pagy_link_proc(pagy)
    link.call(2)
    #=> <a href="...?page=2" data-remote="true">2</a>
    ```

3. For all the `link.call`: pass an extra attributes string to the `pagy_link_proc`:

    ```ruby
    # in any view
    link = pagy_link_proc(pagy, 'class="page-link"')
    link.call(2)
    #=> <a href="...?page=2" data-remote="true" class="page-link">2</a>
    link.call(3)
    #=> <a href="...?page=3" data-remote="true" class="page-link">3</a>
    ```

4. For a single `link.call`: pass an extra attributes string when you call the proc:

    ```ruby
    # in any view
    link.call(page_number, 'aria-label="my-label"')
    #=> <a href="...?page=2" data-remote="true" class="page-link" aria-label="my-label">2</a>
    ```

#### CAVEATS

We use only strings for performance, so the attribute strings get concatenated level after level, but not merged!

Be careful not to pass the same attribute at different levels multiple times. That would generate a duplicated HTML attribute which is illegal html (although handled by all mayor browsers by ignoring all the duplicates but the first).

Specifically do not add a `class` attribute that will end up in the `pagy_bootstrap_nav_js`, `pagy_semantic_nav_js` and `pagy_semantic_combo_nav_js`, which define already their own.

### pagy_t(key, vars={})

This method is similar to the `I18n.t` and its equivalent rails `t` helper. It is called internally (from helpers and templates) in order to get the interpolated strings out of a YAML dictionary file. _(see I18n below)_

## I18n

Pagy can provide i18n using its own recommended super fast implementation (see the [Pagy::I18n](i18n.md) doc) or can use the slower standard `i18n` gem (see the [i18n extra](../extras/i18n.md) doc).

### Dictionaries/locales

Pagy provides many ready-to-use dictionaries for different locales/languages usable with single or multi languages apps.

All the pagy strings are are stored in the dictionary files of its [locales](https://github.com/ddnexus/pagy/blob/master/lib/locales), ready to be customized and/or used with or without the `I18n` gem. The files follow the same structure of the standard locale files for the `i18n` gem.

**IMPORTANT**: if you are using pagy with some language missing from the [locales](https://github.com/ddnexus/pagy/blob/master/lib/locales), please, submit your translation!
