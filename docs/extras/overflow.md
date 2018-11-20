---
title: Overflow
---
# Overflow Extra

This extra allows for easy handling of overflowing pages. It internally rescues from the `Pagy::OverflowError` offering a few different ready to use modes, quite useful for UIs and/or APIs. It works with `Pagy` or `Pagy::Countless` instances.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/overflow'

# default :empty_page (other options :last_page and :exception )
Pagy::VARS[:overflow] = :last_page

# OR
require 'pagy/countless'
require 'pagy/extras/overflow'

# default :empty_page (other option :exception )
Pagy::VARS[:overflow] = :exception

```

## Files

This extra is composed of the [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb) file.

## Variables

| Variable    | Description                                              | Default      |
| ------------| -------------------------------------------------------- | ------------ |
| `:overflow` | one of `:last_page`, `:empty_page` or `:exception` modes | `:empty_page` |

As usual, depending on the scope of the customization, you have a couple of options to set the variables:

As a global default:

```ruby
Pagy::VARS[:overflow] = :empty_page
```

For a single instance (overriding the global default):

```ruby
pagy(scope, overflow: :empty_page)
Pagy.new(count:100,  overflow: :empty_page)
```

## Modes

These are the modes accepted by the `:overflow` variable:

### :last_page

**Notice**: Not available for `Pagy::Countless` instances.

It is useful in apps with an UI, in order to avoid to redirect to the last page.

Regardless the overflowing page requested, Pagy will set the page to the last page and paginate exactly as if the last page has been requested. For example:

```ruby
# no exception passing an overflowing page (Default mode :last_page)
pagy = Pagy.new(count: 100, page: 100)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 5   (current/last page)
pagy.last == pagy.page  #=> true
```

### :empty_page

This is the default mode; it will paginate the actual requested page, which - being overflowing - is empty. It is useful with APIs, where the client expects an empty set of results in order to stop requesting further pages.

Example for `Pagy` instance:

```ruby
pagy = Pagy.new(count: 100, page: 100, overflow: :empty_page)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 100 (actual empty page)
pagy.last == pagy.page  #=> false
pagy.last               #=> 5
pagy.last == pagy.prev  #=> true (the prev page is the last page relative to the overflowing page)
pagy.next               #=> nil
pagy.offset             #=> 0
pagy.from               #=> 0
pagy.to                 #=> 0
pagy.series             #=>  [1, 2, 3, 4, 5] (no string, so no current page highlighted in the UI)
```

Example for `Pagy::Countless` instance:

```ruby
require 'pagy/countless'
require 'pagy/extras/overflow'

pagy = Pagy::Countless.new(count: 100, page: 100, overflow: :empty_page).finalize(0)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 100 (actual empty page)
pagy.last == pagy.page  #=> false
pagy.last               #=> nil
pagy.last == pagy.prev  #=> true (but nil)
pagy.next               #=> nil
pagy.offset             #=> 0
pagy.from               #=> 0
pagy.to                 #=> 0
pagy.series             #=>  [] (no pages)
```

### :exception

This mode raises the `Pagy::OverflowError` as usual, so you can rescue from and do what is needed. It is useful when you need to use your own custom mode even in presence of this extra (which would not raise any error).

## Methods

### overflow?

Use this method in order to know if the requested page is overflowing. The original requested page is available as `pagy.vars[:page]` (useful when used with the `:last_page` mode, in case you want to give some feedback about the rescue to the user/client).
