---
title: Pagy::Frontend
---
# Pagy::Frontend

This module provides a few methods to deal with the navigation aspect of the pagination. You will usually include it in some helper module, making its methods available (and overridable) in your views. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb))_

You can extend this module with a few more `nav_*` helpers _(see the [extras](../extras.md) doc for more details)_

## Synopsis

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

Pagy is i18n ready. That means that all its strings are stored in the dictionary files of its [locales](https://github.com/ddnexus/pagy/blob/master/lib/locales), ready to be customized and/or used with or without the `I18n` gem.

**Notice**: a Pagy dictionary file is a YAML file containing a few entries used internally in the the UI by helpers and templates through the [pagy_t](#pagy_tpath-vars) method. The file follows the same structure of the standard locale files for the `i18n` gem.

### Pagy I18N implementation

The pagy internal i18n implementation is ~12x faster and uses ~6x less memory than the standard `i18n` gem.

Since Pagy version 2.0, you can use it for both single-language and multi-language apps, with or without the `i18n` gem.

Notice: if your app is using i18n, it will work independently from it.

The pagy internal i18n is implemented around the `Pagy::Frontend::I18N` constant hash which contains the locales data needed to pagy and your app. You may need to configure it in the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer.

#### Pagy::Frontend::I18N.load configuration

By default pagy will render its output using the built-in `en` locale. If your app uses only `en` and you are fine with the built-in strings, you are done without configuring anything at all.

If you need to load different built-in locales, and/or custom dictionary files or even non built-in languages and pluralizations, you can do it all by passing a few arguments to the `Pagy::Frontend::I18N.load` method.

**Notice**: the `Pagy::Frontend::I18N.load` method is intended to be used once in the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer. If you use it multiple times, the last statement will override the previous statements.

Here are a few examples that should cover all the possible confgurations:

```rb
# IMPORTANT: use only one load statement

# load the "de" built-in locale:
Pagy::Frontend::I18N.load(locale: 'de') 

# load the "de" locale defined in the custom file at :filepath:
Pagy::Frontend::I18N.load(locale: 'de', filepath: 'path/to/pagy-de.yml') 

# load the "de", "en" and "es" built-in locales:
# the first :locale will be used also as the default_locale
Pagy::Frontend::I18N.load({locale: 'de'}, 
                          {locale: 'en'}, 
                          {locale: 'es'})
 
# load the "en" built-in locale, a custom "es" locale, and a totally custom locale complete with the :pluralize proc:
Pagy::Frontend::I18N.load({locale: 'en'}, 
                          {locale: 'es', filepath: 'path/to/pagy-es.yml'},
                          {locale: 'xyz',  # not built-in
                           filepath: 'path/to/pagy-xyz.yml',
                           pluralize: lambda{|count| ... } )
```

**Notice**: You should use a custom `:pluralize` proc only for pluralization types not included in the built-in [p11n.rb](https://github.com/ddnexus/pagy/blob/master/lib/locales/p11n.rb)
 rules. In that case, please submit a PR with your dictionary file and plural rule. The `:pluralize` proc should receive the `count` as a single argument and should return the plural type string (e.g. something like `'zero'`, `'one'` or `'other'`, depending on the passed count).

#### Set the request locale in multi-language apps

When you configure multiple locales, you must also set the locale for each request. You usually do that in the application controller, by checking the `:locale` param. For example, in a rails app you should do something like:

```rb
before_action { @pagy_locale = params[:locale] || 'en' }
```

That instance variable will be used by the [pagy_t](#pagy_tpath-vars) method included in your view and will translate the pagy strings to the selected locale.

**Notice**: In case of `@pagy_locale.nil?` or unknown/not-loaded, then the the first loaded locale will be used for the translation. That means that you don't have to set the `@pagy_locale` variable if your app uses just a single locale.

#### Adding the model translations

When Pagy uses its own i18n implementation, it has only access to the strings in its own files and not in other `I18n` files used by the rest of the app.

That means that if you use the `pagy_info` helper with the specific model names instead of the generic "items" string, you may need to add entries for the models in the pagy dictionary files. For example:

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


### Using the I18n gem

If - despite the disadvantages - you want to use the standard `i18n` gem in place of the pagy i18n implementation, you should use the [i18n extra](../extras/i18n.md), which delegates the handling of the pagy strings to the `i18n` gem. In that case you need only to require the extra in the initializer file with `require 'pagy/extras/i18n'` and everything will be handled by the `i18n` gem.

 **Notice**: if you use the [i18n extra](../extras/i18n.md)/`i18n` gem, you don't need any of the above configurations.
