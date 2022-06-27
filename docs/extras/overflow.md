---
title: Overflow
category: Feature Extras
---
# Overflow Extra

This extra allows for easy handling of overflowing pages. It internally rescues from the `Pagy::OverflowError` offering a few different ready to use modes, quite useful for UIs and/or APIs. It works with `Pagy` and its subclasses, although with some little difference.

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/overflow'

# default :empty_page (other options :last_page and :exception )
Pagy::DEFAULT[:overflow] = :last_page

# OR
require 'pagy/countless'
require 'pagy/extras/overflow'

# default :empty_page (other option :exception )
Pagy::DEFAULT[:overflow] = :exception

```

## Files

- [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb)

## Variables

| Variable    | Description                                                                         | Default       |
|:------------|:------------------------------------------------------------------------------------|:--------------|
| `:overflow` | the modes in case of overflowing page (`:last_page`, `:empty_page` or `:exception`) | `:empty_page` |

As usual, depending on the scope of the customization, you have a couple of options to set the variables:

```ruby
# globally
Pagy::DEFAULT[:overflow] = :empty_page

# or for a single instance
@pagy, @records = pagy(scope, overflow: :empty_page)
```

## Modes

These are the modes accepted by the `:overflow` variable:

### :empty_page

This is the default mode; it will paginate the actual requested page, which - being overflowing - is empty. It is useful with APIs, where the client expects an empty set of results in order to stop requesting further pages.

Example for `Pagy` instance:

```ruby
# no exception passing an overflowing page
pagy = Pagy.new(count: 100, page: 100)

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

pagy = Pagy::Countless.new(count: 100, page: 100).finalize(0)

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

Example for `Pagy::Calendar::Month` instance:

```ruby
require 'pagy/calendar'
require 'pagy/extras/overflow'

local_time = Time.new(2021, 10, 20, 10, 10, 10, '-09:00')
# => 2021-10-20 10:10:10 -0900
pagy = Pagy::Calendar::Month.new(period: [local_time, local_time + 60*60*24*130], page: 100)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 100 (actual empty page)
pagy.last == pagy.page  #=> false
pagy.last               #=> 5
pagy.last == pagy.prev  #=> true (the prev page is the last page relative to the overflowing page)
pagy.next               #=> nil
pagy.from               #=> 2022-03-01 00:00:00 -0900 (end time of the final unit)
pagy.to                 #=> 2022-03-01 00:00:00 -0900 (same as from: if used it gets no records)
pagy.series             #=>  [1, 2, 3, 4, 5] (no string, so no current page highlighted in the UI)

# small difference with order: :desc, which yield the same result of an empty page
pagy = Pagy::Calendar::Month.new(order: :desc, period: [local_time, local_time + 60*60*24*130], page: 100)
pagy.from               #=> 2021-10-01 00:00:00 -0900 (start time of initial unit)
pagy.to                 #=> 2021-10-01 00:00:00 -0900 (same as from: if used it gets no records)
```

### :last_page

**Notice**: Not available for `Pagy::Countless` instances since the last page is not known.

It is useful in apps with an UI, in order to avoid to redirect to the last page.

Regardless the overflowing page requested, Pagy will set the page to the last page and paginate exactly as if the last page has been requested. For example:

```ruby
pagy = Pagy.new(count: 100, page: 100, overflow: :last_page)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 5   (current/last page)
pagy.last == pagy.page  #=> true
```

### :exception

This mode raises the `Pagy::OverflowError` as usual, so you can rescue from and implement your own custom mode even in presence of this extra.

```ruby
begin
  pagy = Pagy.new(count: 100, page: 100, overflow: :exception)
rescue Pagy::OverflowError => e
  ...
end
```

## Methods

### overflow?

Use this method in order to know if the requested page is overflowing. The original requested page is available as `pagy.vars[:page]` (useful when used with the `:last_page` mode, in case you want to give some feedback about the rescue to the user/client).

## Errors

See [How to handle Pagy::OverflowError exceptions](/docs/how-to.md#handle-pagyoverflowerror-exceptions)
