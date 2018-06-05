---
title: Pagy
---
# Pagy

The scope of the `Pagy` class is keeping track of the all integers and variables involved in the pagination. It basically takes a few integers (such as the count of the collection, the page number, the items per page, ...), does some simple aritmetic and creates a very small object that allocates less than 3k of memory. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb))_

## Synopsys

```ruby
# set global defaults and extra variables typically in an initializer
# they will get merged with every new Pagy instance
Pagy::VARS[:items]    = 25
Pagy::VARS[:some_var] = 'default value'

# create a new instance (usually done automatically by the #pagy controller method)
pagy = Pagy.new(count: 1000, page: 3, instance_var: 'instance var')
#=> #<Pagy:0x000056070d954330 ... >

# fetch variables (with global default)
pagy.vars[:some_var]
#=> "default value"

# fetch variables passed to the instance
pagy.vars[:instance_var]
#=> "instance var"

# fetch instance attributes
pagy.items
#=> 25

# get the page series
pagy.series
#=> [1, 2, "3", 4, 5, 6, 7, :gap, 40]
```

## Global Variables

The `Pagy::VARS` is a globally available hash used to set defaults variables. It gets merged with (and overridden by) the variables passed with the `new` method every times a `Pagy` instance gets created.

You will typically use it in an initializer file to pass defaults values. For example:

```ruby
Pagy::VARS[:items]     = 25
Pagy::VARS[:my_option] = 'my option'
```

## Methods

### Pagy.root

This method returns the `pathname` of the `pagy/lib` root dir. It is useful to get the absolute path of template, locale and javascript files installed with the gem.

### Pagy.new

_Notice_: If you use the `Pagy::Backend` its `pagy` method will instantiate and return the pagy object for you.

The `Pagy.new` method accepts a single hash of variables that will be merged with the `Pagy::Vars` hash and will be used to create the object. The only mandatory variable is the `:count` of the collection to paginate: all the other variables are optional and have sensible defaults. Of course you will also have to pass the `page` or you will always get the default page number 1.

All the variables not explicitly in the list of core-variables (the non-core variables) passed/merged to the new method will be kept in the object, passed around with it and accessible through the `pagy.vars` hash.

**Notice**: Pagy replaces the blank values of the passed variables with their default values. It also applies `to_i` on the values expected to be integers, so you can use values from request `params` without problems. For example: `pagy(some_scope, items: params[:items])` will work without any additional cleanup.

### Core Variables

These are the core-variables (i.e. instance variables that define the pagination object itself) consumed by the `new` method. They are all integers:

| Variable  | Description                                                                                    | Default |
| --------- | ---------------------------------------------------------------------------------------------- | ------- |
| `:count`  | the total count of the collection to paginate (mandatory argument)                             | `nil`   |
| `:page`   | the requested page number                                                                      | `1`     |
| `:items`  | the _requested_ number of items for the page                                                   | `20`    |
| `:outset` | the initial offset of the collection to paginate: pass it only if the collection had an offset | `0`     |

### Non-core Variables

These are the non-core variables: as for the core-variables they can be set globally by using the `Pagy::VARS` hash or passed to the `Pagy.new` method, but they don't become instance variables. Instead they are items of the `@vars` instance variable hash and are accessible through the `vars` reader.

| Variable      | Description                                                                                                                                                                                     | Default     |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `:size`       | the size of the page links to show: array of initial pages, before current page, after current page, final pages. (see also [Control the page links](../how-to.md#controlling-the-page-links))_ | `[1,4,4,1]` |
| `:page_param` | the name of the page param name used in the url. (see [Customizing the page param](../how-to.md#customizing-the-page-param)                                                                     | `:page`     |
| `:params`     | the arbitrary param hash to add to the url. (see [Customizing the params](../how-to.md#customizing-the-params)                                                                                  | `{}`        |
| `:anchor`     | the arbitrary anchor string (including the "#") to add to the url. (see [Customizing the page param](../how-to.md#customizing-the-params)                                                       | `""`       |
| `:link_extra` | the extra attributes string (formatted as a valid HTML attribute/value pairs) added to the page links                                                                                           | `""`       |
| `:item_path`  | the dictionary path used by the `pagy_info` method to lookup the item/model name                                                                                                                | `""`       |

There is no specific default nor validation for non-core variables.

### Attribute Readers

Pagy exposes all the instance variables needed for the pagination through a few attribute readers. They all return integers (or `nil`), except the `vars` hash:

| Reader   | Description                                                                                                        |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| `count`  | the untouched `:count` variable                                                                                    |
| `page`   | the current page number                                                                                            |
| `items`  | the _actual_ number of items in the current page (can be less than the requested `:items` variable)                |
| `pages`  | the number of total pages in the collection (same as `last` but with cardinal meaning)                             |
| `last`   | the number of the last page in the collection (same as `pages` but with ordinal meaning)                           |
| `offset` | the number of items skipped from the collection in order to get the start of the current page (`:outset` included) |
| `from`   | the collection-position of the first item in the page (`:outset` excluded)                                         |
| `to`     | the collection-position of the last item in the page (`:outset` excluded)                                          |
| `prev`   | the previous page number or `nil` if there is no previous page                                                     |
| `next`   | the next page number or `nil` if there is no next page                                                             |
| `vars`   | the non-core variables hash                                                                                        |

### series(...)

This method is the core of the pagination. It returns an array containing the page numbers and the `:gap` items to be rendered with the navigation links (e.g. `[1, :gap, 7, 8, "9", 10, 11, :gap, 36]`). It accepts an optional `size` argument (only useful for extras), defaulted on the `:size` variable.

The nav helpers and the templates basically loop through this array and render the correct item by simply checking its type:

- if the item is an `Integer` then it is a page link
- if the item is a `String` then it is the current page
- if the item is the `:gap` symbol then it is a gap in the series

That is self-contained, simple and efficient.

### Lowest limit analysys

The lowest possible limit of the pagination is reached when the collection has `0` count. In that case the pagy object created has the following peculiar attributes:

| Attribute | Value   |
| --------- | ------- |
| `count`   | `0`     |
| `page`    | `1`     |
| `items`   | `0`     |
| `pages`   | `1`     |
| `last`    | `1`     |
| `from`    | `0`     |
| `to`      | `0`     |
| `prev`    | `nil`   |
| `next`    | `nil`   |
| `series`  | `["1"]` |

Which means:

- there is always a `page` #`1` in the pagination, even if it's empty
- `pages` and `last` are always at least both `1`
- the `series` array contains always at least the page #`1`, which for a single page is also a string (i.e. the current page)
- the actual number of `items` in an empty page are `0`
- `from` and `to` of an empty page are both `0`
- `prev` and `next` of a single page (not necessary an empty one) are both `nil` (i.e. there is no other page)
