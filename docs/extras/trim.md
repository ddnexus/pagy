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

The `trim` extra overrides the `pagy_link_proc` method in the `Pagy::Frontend` module.

### pagy_link_proc(pagy, link_extra='')

This method trims the `:page_param` param from the first page link. It is alias-chained with `*_with_trim` and `*_without_trim`.

