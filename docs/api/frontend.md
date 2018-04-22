---
title: Pagy::Frontend
---

# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. You will usually include it in some helper module, making its methods available (and overridable) in your views. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb))_


## Synopsys

```ruby
# typically in some helper
include Pagy::Frontend

# optional overriding of some submethod (e.g. massage the params)
def pagy_get_params(params)
  params.except(:anything, :not, :useful).merge!(something: 'more useful')
end
```
use some of its method in some view:

```erb
<%== pagy_nav(@pagy) %>
<%== pagy_info(@pagy) %>
```

## Methods

All the methods in this module are prefixed with the `"pagy_"` string, to avoid any possible conflict with your own methods when you include the module in your helper. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden and not used directly.

Please, keep in mind that overriding any method is very easy with pagy. Indeed you can do it right where you are using it: no need of monkey-patching or subclassing or tricky gymnic.


### pagy_nav(pagy)

This method takes the pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

```erb
<%== pagy_nav(@pagy) %>
```

The `nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

See also [Using templates](../how-to.md#using-templates).


### pagy_info(pagy)

This method provides the info about the content of the current pagination. For example:

```erb
<%== pagy_info(@pagy) %>
```

Will produce something like:

```HTML
Displaying items <b>476-500</b> of <b>1000</b> in total
```

Or, if you provide the `:item_path` variable for the Product model, it will produce a model-specific output like:

```HTML
Displaying Products <b>476-500</b> of <b>1000</b> in total
```

See also [Using the pagy_info helper](../how-to.md#using-the-pagy_info-helper).


### pagy_url_for(n)

This method is called internally in order to produce the url of a page by passing it its number. For standard usage it works out of the box and you can just ignore it.

For more advanced usage, you may want to override it in order to fit its behavior with your app needs (e.g.: allowing fancy routes, etc.).

Notice: If you just need to remove or add some param, you may prefer to override the `pagy_get_params` method instead.

See also [Customizing the URL](../how-to.md#customizing-the-url).


### pagy_get_params(params)

Sub-method called by `pagy_url_for`: it is intended to be overridden when you need to add and/or remove some param from the page URLs. It receives the `params` hash complete with the `"page"` param and should return a possibly modified version of it.

See also [Customizing the params](../how-to.md#customizing-the-params).


### pagy_link_proc(pagy, link_extra='')

This method is called internally to get a very specialized and fast proc that produce the HTML links for the pages.

For standard usage you may just need to read [Customizing the link attributes](../how-to.md#customizing-the-link-attributes), for advanced usage see below.


### Advanced Usage

You need this section only if you are going to override a `pagy_nav*` helper or a template AND you need to customize the HTML attributes of the link tags.

**Important**: This method is not intended to be overridden, however you could just replace it in your overridden `pagy_nav*` helpers or templates with some generic helper like the rails `link_to`. If you intend to do so, be sure to have a very good reason, since using `pagy_link_proc` is a lot faster than the rails `link_to` (benchmarked at ~27x faster using ~13x less memory on a 20 links nav).

**Warning**: This is a peculiar way to create page links and it works only for that purpose. It is not intended to be used for any other generic links to any URLs different than a page link.

This method returns a specialized proc that you call to produce the page links. The reason it is a 2 steps process instead of a single method call is performance.

Here is how you should use it: in your helper or template call the method to get the proc (just once):
```
link = pagy_link_proc( pagy [, extra_attributes_string ])
```

Then call the `"link"` proc to get the links (multiple times):
```
link.call( page_number [, text [, extra_attributes_string ]])
```

### Extra attribute strings

If you need to add some HTML attribute to the page links, you can pass some extra attribute string at many levels, depending on the scope you want your attributes to be added.

**Important**: For performance reasons, the extra attributes strings must be formatted as valid HTML attribute/value pairs. _All_ the stringa spassed at any level will get inserted verbatim in the HTML of the link.

1. For all pagy objects: set the global variable `:link_extra`:
    ```ruby
    # in an initializer file
    Pagy::VARS[:link_extra] = 'data-remote="true"'
    # in any view
    link = pagy_link_proc(pagy) 
    link.call(2)
    #=> <a href="...?page=2" data-remote="true">2</a>
    ```
2. For one pagy object: pass the `:link_extra` variable to a pagy constructor (`Pagy.new` or `pagy` controller method):
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
**WARNING**: we use only strings for performance, so the attribute strings get concatenated level after level, but not merged!
Be careful not to pass the same attribute at different levels multiple times. That would generate a duplicated HTML attribute which is illegal html (although handled by all mayor browsers by ignoring all the duplicates but the first)


### pagy_t(path, vars={})

This method is similar to the `I18n.t` and its equivalent rails `t` helper. It is called internally (from helpers and templates) in order to get the interpolated strings out of a YAML locale file.

This method may be defined in 2 different ways:

- if `I18n` is defined: it is defined to use the standard `I18n.t` helper. _It's 5x slower but provides full I18n features_.
- if `I18n` is missing or the `Pagy::I18N[:gem]` variable (see below) is explicitly set to `false`: it is defined to use the pagy I18n-like implementation. _It's 5x faster but provides only pluralization/interpolation without translation, so it's only useful with single language apps_.

See also [Using I18n](../how-to.md#using-i18n).


### I18n Global Variables

These are the `Pagy::I18N` globally accessible variables used to configure I18n. They are not merged with the pagy object and used only at require time.

|   Variable | Description                                                    | Default                                      |
|-----------:|:---------------------------------------------------------------|:---------------------------------------------|
|     `:gem` | Boolean: use the standard `I81n` gem?                          | `nil`                                        |
|    `:file` | The I18n YAML file                                             | `Pagy.root.join('locales', 'pagy.yml').to_s` |
| `:plurals` | The proc that returns the plural key based on the passed count | `Proc` for English                           |


#### Pagy::I18N[:gem]

Pagy will define the `pagy_t` method to use the `I18n` gem if available, or the pagy internal implementation if `I18n` is missing.

That works in all conditions, however - for performance reasons - you may want to force using the internal 5x faster implementation even in presence of `I18n` (e.g. with rails). You should do so only in case of single-language apps (e.g. only 'en', or only 'fr'...) since the internal implementation supports only pluralization and interpolation but not translation.

If you want to force the internal faster implementation, you should explicitly set `Pagy::I18N[:gem] = false` in an initializer. In case you are also using the `pagy-extras` you should also ensure to require it only after the `Pagy::I18N[:gem]` variable has been set.


#### Pagy::I18N[:file]

This variable contains the path of the YAML file to load: set this variable only if you customized the file.


#### Pagy::I18N[:plurals]

This variable controls the internal pluralization. If `pagy_t` is defined to use `I18n.t` it has no effect.

By default the variable is set to a proc that receives the `count` as the single argument and returns the plural type string (e.g. something like `'zero'`, `'one'` or `'other'`, depending on the count). You should customize it only for pluralization types different than English.

See also [Using I18n](../how-to.md#using-i18n).
