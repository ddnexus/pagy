---
title: Overflow
categories:
- Feature
- Extra
---

# Overflow Extra

Allow easy handling of overflowing pages (i.e. requested page > count).

It internally rescues `Pagy::OverflowError` exceptions offering the following ready to use
behaviors/modes: `:empty_page`, `:last_page`, and `:exception`.

## Synopsis

||| pagy.rb (initializer)

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

|||

## Files

- [overflow.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/overflow.rb)

## Variables

| Variable    | Description                                                                         | Default       |
|:------------|:------------------------------------------------------------------------------------|:--------------|
| `:overflow` | the modes in case of overflowing page (`:last_page`, `:empty_page` or `:exception`) | `:empty_page` |

Set the variables - either globally, or locally:

```ruby
# globally: e,g, pagy.rb Initializer
Pagy::DEFAULT[:overflow] = :empty_page

# or for a single instance e.g. in a controller
@pagy, @records = pagy(scope, overflow: :empty_page)
```

## Modes

The modes accepted by the `:overflow` variable:

- `:empty_page`
- `:last_page`
- `:exception`

+++ :empty_page

!!!success Serve an empty page
Useful for APIs, where clients expect an empty page, in order to stop requesting more pages. This is the default mode.
!!!

||| `Pagy` instance example:

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

|||

||| `Pagy::Countless` instance example:

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

|||

||| `Pagy::Calendar::Month` instance example:

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

|||

+++ :last_page

!!!success Serve the last_page
Paginate exactly as if the last page has been requested.
!!!

!!!warning
The `:last_page` mode is not available for `Pagy::Countless` instances because the last page is not known.
!!!

For example:

||| Controller

```ruby
pagy = Pagy.new(count: 100, page: 100, overflow: :last_page)

pagy.overflow?          #=> true
pagy.vars[:page]        #=> 100 (requested page)
pagy.page               #=> 5   (current/last page)
pagy.last == pagy.page  #=> true
```

|||

+++ :exception

!!!success Raise the `Pagy::OverflowError` as usual
You can rescue from the exception and implement your own custom mode even in presence of this extra.
!!!

```ruby
begin
  pagy = Pagy.new(count: 100, page: 100, overflow: :exception)
rescue Pagy::OverflowError => e
  ...
end
```

+++

## Methods

==- `overflow?`

Use this method in order to know if the requested page is overflowing. The original requested page is available
as `pagy.vars[:page]` (useful when used with the `:last_page` mode, in case you want to give some feedback about the rescue to the
user/client).

===

## Errors

See [How to handle Pagy::OverflowError exceptions](/docs/how-to.md#handle-pagyoverflowerror-exceptions)
