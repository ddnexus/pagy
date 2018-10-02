---
title: Pagy::Frontend
---
# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. You will usually include it in some helper module, making its methods available (and overridable) in your views. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb))_

You can extend this module with a few more `nav_*` helpers _(see the [extras](../extras.md) doc for more details)_

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

All the methods in this module are prefixed with the `"pagy_"` string in order to avoid any possible conflict with your own methods when you include the module in your helper. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden and not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need of monkey-patching or tricky gymnic.

### pagy_nav(pagy)

This method takes the Pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

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

### pagy_url_for(page, pagy)

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

This method returns a specialized proc that you call to produce the page links. The reason it is a 2 steps process instead of a single method call is performance. Indeed the method  calls the potentially expensive `pagy_url_for` only once and generates the proc, then calling the proc will just interpolates the strings passed to it.

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

**Important**: For performance reasons, the extra attributes strings must be formatted as valid HTML attribute/value pairs. _All_ the string spassed at any level will get inserted verbatim in the HTML of the link.

1. For all pagy objects: set the global variable `:link_extra`:
    ```ruby
    # in the pagy.rb initializer file
    Pagy::VARS[:link_extra] = 'data-remote="true"'
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
**WARNING**: we use only strings for performance, so the attribute strings get concatenated level after level, but not merged!
Be careful not to pass the same attribute at different levels multiple times. That would generate a duplicated HTML attribute which is illegal html (although handled by all mayor browsers by ignoring all the duplicates but the first)

### pagy_t(path, vars={})

This method is similar to the `I18n.t` and its equivalent rails `t` helper. It is called internally (from helpers and templates) in order to get the interpolated strings out of a YAML dictionary file. _(see I18n below)_

## I18n

**IMPORTANT**: if you are using pagy with some language missing from the [dictionary files](https://github.com/ddnexus/pagy/blob/master/lib/locales), please, submit your translation!

Pagy is I18n ready. That means that all its strings are stored in a dictionary file of one of its [languages](https://github.com/ddnexus/pagy/blob/master/lib/locales), ready to be customized and/or translated/pluralized and used with or without the `I18n` gem.

A Pagy dictionary file is a YAML file containing a few entries used in the the UI by helpers and templates through the [pagy_t method](#pagy_tpath-vars) (eqivalent to the `I18n.t` or rails `t` helper). The file follows the same structure of the standard locale files for `i18n`.

### Multi-language apps

For multi-language apps you need the dynamic translation provided by the [i18n extra](../extras/i18n.md), which delegates the handling of the pagy strings to the `I18n` gem. In that case you need only to require the I18n extra in the initializer file.

**Notice**: For simplicity, you could also use the `i18n` extra for single-language apps, but if you want more performance, please follow the specific documentation below.

### Single-language apps

Single-language apps (i.e. only `fr` or only `en` or only ...) don't need to switch between languages, so they don't need the `i18n` extra/`I18n` gem (although you could choose to use it).

By default, Pagy handles its own dictionary file directly, providing pluralization and interpolation (without dynamic translation) _5x faster_ and using _3.5x less memory_ than the standard `I18n` gem.

If you are fine with the locales provided with pagy, you just need to load the dictionary file of your language by adding this line the initializer file. For example with `zh-cn`:

```ruby
Pagy::Frontend::I18N.load(file: Pagy.root.join('locales', 'zh-cn.yml'), language:'zh-cn')
```

If you need to use your own translation file and/or customize the Pagy strings in this scenario, you may need the following steps:

1. copy and edit one of the [dictionary files](https://github.com/ddnexus/pagy/blob/master/lib/locales)
2. load it in the initializer file (e.g. `Pagy::Frontend::I18N.load(file:..., language:'tr')`
3. see [Adding the model translations](#adding-the-model-translations) below
4. check if you need to configure some of the following variables in the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer.

#### Pagy::Frontend::I18N Constant

**IMPORTANT**: This variable has no effect if you use the `i18n` extra.

The `Pagy::Frontend::I18N` constant is the core of the Pagy I18n implementation. This constant allows to control the dictionary file, the language to load and the pluralization proc.

#### Pagy::Frontend::I18N.load(file:..., language:'en')

**IMPORTANT**: This method has no effect if you use the `i18n` extra.

It allows to load a built-in language (different than the default 'en') and/or a custom dictionary file, different from `Pagy.root.join('locales', 'pagy.yml')`. It is tipically used in the Pagy initializer file _(see [Configuration](../how-to.md#global-configuration))_. For example:

```ruby
# this would load the Italian variant of the built-in dictionary
Pagy::Frontend::I18N.load(language:'it')

# this would load the default English variant of 'path/to/dictionary.yml'
Pagy::Frontend::I18N.load(file:'path/to/dictionary.yml')

# this would load the Italian variant of 'path/to/dictionary.yml'
Pagy::Frontend::I18N.load(file:'path/to/dictionary.yml', language:'it')
```

**Notice**: the Pagy implementation of I18n is designed to speedup single-language apps and does not provide dynamic translation, so the `language` is statically loaded at startup-time and cannot be changed. Use the `i18n` extra if you need dynamic translation.

#### Pagy::Frontend::I18N[:plural]

**IMPORTANT**: This variable has no effect if you use the `i18n` extra.

This variable controls the internal pluralization.

Pagy tries to set the language plural proc when you use the `Pagy::Frontend::I18N.load` method, by loading the built-in plural for the language. _(see [plurals.rb](https://github.com/ddnexus/pagy/blob/master/lib/locales/plurals.rb))_

If there is no rule defined for the language loaded, the variable is set to the `:zero_one_other` plural rule (default for English language).

If your custom language requires a pluralization different than `:zero_one_other`, you should define a custom rule. For example:

```ruby
# this would apply a custom pluralization rule to the current loaded dictionary
Pagy::Frontend::I18N[:plural] = -> (count) {|count| ...}
```

The custom proc should receive the `count` as a single argument and should return the plural type string (e.g. something like `'zero'`, `'one'` or `'other'`, depending on the passed count). You should customize it only for pluralization types not included in the built-in plural rules. In that case, please submit a PR with your dictionary file and plural rule. Thanks.

#### Adding the model translations

When Pagy uses its own handling of the dictionary file, it has only access to the strings in its own file and not in other `I18n` files used by the rest of the app.

That means that if you use the `pagy_info` helper with the specific model names instead of the generic "items" string, you may need to add entries for the models in the pagy dictionary file. For example:

```yaml
en:
  pagy:
    ...

  # added models strings
  activerecord:
    models:
      product:
        zero: Products
        one: Product
        other: Products
      ...
```

_(See also the [pagy_info method](#pagy_infopagy))_
