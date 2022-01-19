---
title: Pagy
---
# Pagy

The scope of the `Pagy` class is keeping track of the all integers and variables involved in the pagination. It basically takes a few integers (such as the count of the collection, the page number, the items per page, ...), does some simple arithmetic and creates a very small object that allocates less than 3k of memory. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb))_

## Synopsis

```ruby
# set global defaults and extra variables typically in the pagy.rb initializer
# they will get merged with every new Pagy instance
Pagy::DEFAULT[:items]    = 25
Pagy::DEFAULT[:some_var] = 'default value'

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

## Global Default

The `Pagy::DEFAULT` is a globally available hash used to set defaults variables. It is a constant for easy access, but it is mutable to allow customizable defaults. You can override it in the `pagy.rb` initializer file in order to set your own application global defaults. After you are done, you should `freeze` it, so it will not changed accidentally. It gets merged with the variables passed with the `new` method every times a `Pagy` instance gets created.

You will typically use it in a `pagy.rb` initializer file to pass defaults values. For example:

```ruby
Pagy::DEFAULT[:items]     = 25
Pagy::DEFAULT[:my_option] = 'my option'
...
Pagy::DEFAULT.freeze
```

## Methods

### Pagy.root

This method returns the `pathname` of the `pagy/lib` root dir. It is useful to get the absolute path of template, locale and javascript files installed with the gem.

### Pagy.new(vars)

_Notice_: If you use the `Pagy::Backend` its `pagy` method will instantiate and return the Pagy object for you.

The `Pagy.new` method accepts a single hash of variables that will be merged with the `Pagy::DEFAULT` hash and will be used to create the object.

### series(...)

This method is the core of the pagination. It returns an array containing the page numbers and the `:gap` items to be rendered with the navigation links (e.g. `[1, :gap, 7, 8, "9", 10, 11, :gap, 36]`). It accepts an optional `size` keyword argument (only useful for extras), defaulted on the `:size` variable.

**Notice**: A `:gap` is added only where the series is missing at least two pages. When the series is missing only one page, the `:gap` is replaced with the page link of the actual missing page. That's because the page link uses the same space of the `...` gap but it is more useful.

The nav helpers and the templates basically loop through this array and render the correct item by simply checking its type:

- if the item is an `Integer` then it is a page link
- if the item is a `String` then it is the current page
- if the item is the `:gap` symbol then it is a gap in the series

That is self-contained, simple and efficient.

**Notice**: This method returns an empty array if the passed `size` (i.e. the `:size` variable by default) is set to an empty array. Useful to totally skip the generation of page links in the frontend.

### label

Experimental: Its only function in the `Pagy` class is supporting the API of various frontend methods that require labelling for `Pagy::Calendar` instances. It returns the current page label that will get displayed in the helpers/templates.

### label_for(page)

Experimental: Its only function in the `Pagy` class is supporting the API of various frontend methods that require labelling for `Pagy::Calendar` instances. It returns the page label that will get displayed in the helpers/templates.

## Variables

All the variables passed to the new method will be merged with the `Pagy::DEFAULT` hash and will be kept in the object, passed around with it and accessible through the `pagy.vars` hash.

They can be set globally by using the `Pagy::DEFAULT` hash or passed to the `Pagy.new` method and are accessible through the `vars` reader.

**Notice**: Pagy replaces the blank values of the passed variables with their default values coming from the `Pagy::DEFAULT` hash. It also applies `to_i` on the values expected to be integers, so you can use values from request `params` without problems. For example: `pagy(some_scope, items: params[:items])` will work without any additional cleanup.

### Instance Variables

A few variables are particularly important for the calculation of the pagination, and therefore are validated and used to initialize a few instance variables.

The only mandatory instance variable to be passed is the `:count` of the collection to paginate: all the other variables are optional and have sensible defaults. Of course you will also have to pass the `page` or you will always get the default page number 1.
They are all integers:

| Variable  | Description                                                                                    | Default |
|:----------|:-----------------------------------------------------------------------------------------------|:--------|
| `:count`  | The total count of the collection to paginate (mandatory argument)                             | `nil`   |
| `:page`   | The requested page number                                                                      | `1`     |
| `:items`  | The requested number of items for the page                                                     | `20`    |
| `:outset` | The initial offset of the collection to paginate: pass it only if the collection had an offset | `0`     |

### Other Variables

| Variable      | Description                                                                                                                                                                                          | Default            |
|:--------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------|
| `:size`       | The size of the page links to show: array of initial pages, before current page, after current page, final pages. _(see also [How to control the page links](../how-to.md#control-the-page-links))_ | `[1,4,4,1]`        |
| `:page_param` | The name of the page param name used in the url. _(see [How to customize the page param](../how-to.md#customize-the-page-param))_                                                                    | `:page`            |
| `:params`     | It can be a `Hash` of params to add to the URL, or a `Proc` that can edit/add/delete the request params _(see [How to customize the params](../how-to.md#customize-the-params))_                     | `{}`               |
| `:fragment`   | The arbitrary fragment string (including the "#") to add to the url. _(see [How to customize the params](../how-to.md#customize-the-params))_                                                        | `""`               |
| `:link_extra` | The extra attributes string (formatted as a valid HTML attribute/value pairs) added to the page links _(see [How to customize the link attributes](../how-to.md#customize-the-link-attributes))_     | `""`               |
| `:i18n_key`   | The i18n key to lookup the `item_name` that gets interpolated in a few helper outputs _(see [How to customize the item name](../how-to.md#customize-the-item-name))_                                 | `"pagy.item_name"` |
| `:cycle`      | Enable cycling/circular/infinite pagination: `true` sets `next` to `1` when the current page is the last page                                                                                        | `false`            |

There is no specific validation for non-instance variables.

### Attribute Readers

Pagy exposes all the instance variables needed for the pagination through a few attribute readers. They all return integers (or `nil`), except the `vars` hash:

| Reader   | Description                                                                                                        |
|:---------|:-------------------------------------------------------------------------------------------------------------------|
| `count`  | The collection `:count`                                                                                            |
| `page`   | The current page number                                                                                            |
| `items`  | The requested number of items for the page                                                                         |
| `pages`  | The number of total pages in the collection (same as `last` but with cardinal meaning)                             |
| `in`     | The number of the items in the page                                                                                |
| `last`   | The number of the last page in the collection (same as `pages` but with ordinal meaning)                           |
| `offset` | The number of items skipped from the collection in order to get the start of the current page (`:outset` included) |
| `from`   | The collection-position of the first item in the page (`:outset` excluded)                                         |
| `to`     | The collection-position of the last item in the page (`:outset` excluded)                                          |
| `prev`   | The previous page number or `nil` if there is no previous page                                                     |
| `next`   | The next page number or `nil` if there is no next page                                                             |
| `vars`   | The variables hash                                                                                                 |
| `params` | The `:params` variable (`Hash` or `Proc`)                                                                          |

### Lowest limit analysis

The lowest possible limit of the pagination is reached when the collection has `0` count. In that case the Pagy object created has the following peculiar attributes:

| Attribute | Value   |
|:----------|:--------|
| `count`   | `0`     |
| `page`    | `1`     |
| `pages`   | `1`     |
| `last`    | `1`     |
| `in`      | `0`     |
| `from`    | `0`     |
| `to`      | `0`     |
| `prev`    | `nil`   |
| `next`    | `nil`   |
| `series`  | `["1"]` |

Which means:

- there is always a `page` #`1` in the pagination, even if it's empty
- `pages` and `last` are always at least both `1`
- the `series` array contains always at least the page #`1`, which for a single page is also the current page, thus a string. With `size: []` the `series` method returns `[]`
- `in`, `from` and `to` of an empty page are all `0`
- `prev` and `next` of a single page (not necessary an empty one) are both `nil` (i.e. there is no other page)

## Exceptions

### Pagy::VariableError

A subclass of `ArgumentError` that offers a few information for easy exception handling when some of the variable passed to the constructor is not valid.

```ruby
rescue Pagy::VariableError => e
  e.pagy     #=> the pagy object that raised the exception
  e.variable #=> the offending variable symbol (e.g. :page)
  e.value    #=> the value of the offending variable (e.g -3)
end
```

Mostly useful if you want to rescue from bad user input (e.g. illegal URL manipulation).

### Pagy::OverflowError

A subclass of `Pagy::VariableError`: it is raised when the `:page` variable exceeds the maximum possible value calculated for the `:count`, i.e. the `:page` variable is in the correct range, but it's not consistent with the current `:count`. That may happen when the `:count` has been reduced after a page link has been generated (e.g. some record has been just removed from the DB). See also the [overflow](../extras/overflow.md) extra.
