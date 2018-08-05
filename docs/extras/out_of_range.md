---
title: Out Of Range
---
# Out Of Range Extra

This extra allows for easy handling of out of range pages. It internally rescues from the `Pagy::OutOfRangeError` offering a few different ready to use modes, quite useful for UIs and/or APIs.

## Synopsys

See [extras](../extras.md) for general usage info.

In the Pagy initializer:

```ruby
require 'pagy/extras/out_of_range'

# default :last_page (other options :empty_page and :exception )
Pagy::VARS[:out_of_range_mode] = :last_page
```

## Files

This extra is composed of the [out_of_range.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/out_of_range.rb) file.

## Variables

| Variable             | Description                                | Default      |
| -------------------- | ------------------------------------------ | ------------ |
| `:out_of_range_mode` | `:last_page`, `empty_page` or `:exception` | `:last_page` |

As usual, depending on the scope of the customization, you have a couple of options to set the variables:

As a global default:

```ruby
Pagy::VARS[:out_of_range_mode] = :empty_page
```

For a single instance (overriding the global default):

```ruby
pagy(scope, out_of_range_mode: :empty_page)
Pagy.new(count:100,  out_of_range_mode: :empty_page)
```

## Modes

These are the modes accepted by the `:out_of_range_mode` variable:

### :last_page

This is the default mode. It is useful in apps with an UI, in order to avoid to redirect to the last page.

Regardless the out of range page requested, Pagy will set the page to the last page and paginate exactly as if the last page has been requested. For example:

```ruby
# no exception passing an out of range page (Default mode :last_page)
pagy = Pagy.new(count: 100, page: 100)

pagy.out_of_range?      #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 5   (current/last page)
pagy.last == pagy.page  #=> true
```

### :empty_page

This mode will paginate the actual requested page, which - being out of range - is empty. It is useful with APIs, where the client expects an empty set of results in order to stop requesting further pages. For example:

```ruby
pagy = Pagy.new(count: 100, page: 100, out_of_range_mode: :empty_page)

pagy.out_of_range?      #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 100 (actual empty page)
pagy.last == pagy.page  #=> false
pagy.last               #=> 5
pagy.last == pagy.prev  #=> true (the prev page is the last page relative to out of range page)
pagy.next               #=> nil
pagy.offset             #=> 0
pagy.from               #=> 0
pagy.to                 #=> 0
pagy.series             #=>  [1, 2, 3, 4, 5] (no string, so no current page highlighted in the UI)
```

### :exception

This mode raises the `Pagy::OutOfRangeError` as usual, so you can rescue from and do what is needed. It is useful when you need to use your own custom mode even in presence of this extra (which would not raise any error).

## Methods

### out_of_range?

Use this method in order to know if the requested page is out of range. The original requested page is available as `pagy.vars[:page]` (useful when used with the `:last_page` mode, in case you want to give some feedback about the rescue to the user/client).
