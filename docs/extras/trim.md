---
title: Trim
---
# Trim Extra

This extra removes the `page=1` param from the link of the first page. You need only to require the extra in the initializer file.

This extra is needed only for very specific scenarios, for example if you need to avoid frontend cache duplicates of the first page.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/trim'
```

## Files

- [trim.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/trim.rb)

## Variables

| Variable | Description      | Default |
|:---------|:-----------------|:--------|
| `:trim`  | is trim enabled? | `true`  |

You can use the `:trim` variable to opt-out of trimming even when the extra is required (trimming by default).

You can set the `Pagy::VARS[:trim]` default to `false` if you want to explicitly pass the `trim: true` variable in order to trim the param.

## Methods

The `trim` extra overrides the `pagy_link_proc` method in the `Pagy::Frontend` module.

### pagy_link_proc(pagy, link_extra='')

This method trims the `:page_param` param from the first page link.

