---
title: Size
image: none
categories:
- Extra
---

# Size Extra

Enable the Array type for the `:size` variable (e.g. `size: [1,4,4,1]`) that generates the legacy nav bar.

!!!danger Use only if REALLY required!
The behavior of the legacy nav bar was taken straight from WillPaginate and kaminari: it's ill-concieved and complicates the 
experience of devs and users.

The legacy bar grows in size from different ends depending on the current page position and its proximity to the start or end 
pages. That changes during navigation are quite unexpected for both devs and users.

Devs have a hard time predicting the real estate occupied by the bar in their layouts, and users have an UI that constantly 
moves its elements around during navigation.

!!!success
Use the default pagy [fast nav](../how-to/#fast-nav) bar for a stable UI and a much better experience!
!!!

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/size'
```

```ruby Controller (action)
# generates a legacy bar  
pagy, records = pagy(collection, size: [1, 4, 4, 1])
pagy.series
#=> [1, :gap, 6, 7, 8, 9, "10", 11, 12, 13, 14, :gap, 50]

# the faster bar is still available if you use the pagy default
pagy, records = pagy(collection)
pagy.series
#=> [1, :gap, 9, "10", 11, :gap, 50]

# or explicitly using an integer
pagy, records = pagy(collection, size: 9)
pagy.series
#=> [1, :gap, 8, 9, "10", 11, 12, :gap, 50]
```

##  Concept and usage

Besides the regular integer value generating the fast bar, you can set the `:size` variable to an array of 4 integers in order to specify which and how many page links to show.

For example: `[1,4,4,1]` means that you will get `1` initial page, `4` pages before the current page, `4` pages after the current page, and `1` final page.

As usual you can set the `:size` variable as a global default by using the `Pagy::DEFAULT` hash or pass it directly to the 
`pagy` method.

The navigation links will contain the number of pages set in the variables:

`size[0]`...`size[1]` current page `size[2]`...`size[3]` - e.g.:

```ruby
pagy, records = pagy(collection, size: [3, 4, 4, 3])
pagy.series
#=> [1, 2, 3, :gap, 6, 7, 8, 9, "10", 11, 12, 13, 14, :gap, 48, 49, 50]
```

As you can see by the result of the `series` method, you get 3 initial pages, 1 `:gap` (series interrupted), 4 pages before the current page, the current `:page` (which is a string), 4 pages after the current page, another `:gap` and 3 final pages.

You can easily try different options (also asymmetrical) in a console by changing the `:size`. Just check the `series` array to see what it contains when used in combination with different core variables.
