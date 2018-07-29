---
title: Trim
---
# Trim Extra

This extra removes the `page=1` param from the link of the first page. You need only to require the extra in the initializer file.

This extra is needed only for very specific scenarios, for example if you need to avoid frontend cache duplicates.

## Synopsys

See [extras](../extras.md) for general usage info.

```ruby
# in the Pagy initializer
require 'pagy/extras/trim'
```

## Files

This extra is composed of 1 small file:

- [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb)

## Methods

The `items` extra overrides one method and adds a utility helper to the `Pagy::Frontend` module. The overridden method is alias-chained with `*_with_trim` and `*_without_trim`)

### pagy_link_proc(pagy, link_extra='')

This extra overrides the `pagy_link_proc` method of the `Pagy::Frontend` module in order to trim the `:page_param` param from the first page link.

### pagy_trim_url(url, param_string)

This is the utility helper used internally in order to remove the `param_string` from the `url`. The `param_string` must be the complete string of name and value: e.g. `"page=1"`.


