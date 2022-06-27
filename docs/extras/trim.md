---
title: Trim
category: Feature Extras
---
# Trim Extra

This extra removes the `page=1` param from the link of the first page. You need only to require the extra in the initializer file.

This extra is needed only for very specific scenarios, for example if you need to avoid frontend cache duplicates of the first page.

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/trim'

# it will trim without any further configuration,

# you can disable it explicitly for specific requests
@pagy, @records = pagy(Product.all, trim_extra: false)

# or...

# disable it by default (opt-in)
Pagy::DEFAULT[:trim_extra] = false   # default true
# in this case you have to enable it explicitly when you want the trimming
@pagy, @records = pagy(Product.all, trim_extra: true)
```

## Files

- [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb)

## Variables

| Variable      | Description                   | Default |
| :------------ | :---------------------------- | :------ |
| `:trim_extra` | enable or disable the feature | `true`  |

You can use the `:trim_extra` variable to opt-out of trimming even when the extra is required (trimming by default).

You can set the `Pagy::DEFAULT[:trim_extra]` default to `false` if you want to explicitly pass the `trim_extra: true` variable in order to trim the page param.

## Methods

The `trim` extra overrides the `pagy_link_proc` method in the `Pagy::Frontend` module.

### pagy_link_proc(pagy, link_extra='')

This method overrides the `pagy_link_proc` using the `pagy_trim` to process the link to the first page.

### pagy_trim(pagy, link)

Sub-method called only by the `pagy_link_proc` method, it removes the the `:page_param` param from the first page link (usually `page=1`).

Override this method if you are [customizing the urls](../how-to.md#customize-the-url).

If you use a `pagy_*nav_js` helper you should customize also the `Pagy.trim` javascript function.
