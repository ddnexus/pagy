---
title: Pagy
categories:
  - Core
  - Class
---

# Pagy

The scope of the `Pagy` class is keeping track of the all integers and variables involved in the pagination. It basically takes a
few integers (such as the count of the collection, the page number, the items per page, ...), does some simple arithmetic and
creates a very small object that allocates less than 3k of memory.

## Synopsis

```ruby pagy.rb (initializer)
# set global defaults and extra variables
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

The `Pagy::DEFAULT` is a globally available hash used to set defaults variables. It is a constant for easy access, but it is
mutable to allow customizable defaults. You can override it in the `pagy.rb` initializer file in order to set your own application
global defaults. After you are done, you should `freeze` it, so it will not change accidentally. It gets merged with the
variables passed with the `new` method every times a `Pagy` instance gets created.

You will typically use it in a `pagy.rb` initializer file to pass defaults values. For example:

```ruby pagy.rb (initializer)
Pagy::DEFAULT[:items]     = 25
Pagy::DEFAULT[:my_option] = 'my option'
...
Pagy::DEFAULT.freeze
```

## Methods

==- `Pagy.root`

This method returns the `pathname` of the `pagy/gem` root dir. It is useful to get the absolute path of locale and javascript
files installed with the gem.

==- `Pagy.new(vars)`

_Notice_: If you use the `Pagy::Backend` its `pagy` method will instantiate and return the Pagy object for you.

The `Pagy.new` method accepts a single hash of variables that will be merged with the `Pagy::DEFAULT` hash and will be used to
create the object.

==- `series(size: @vars[:size], _**)`

This method is the core of the pagination. It returns an array containing the page numbers and the `:gap` items to be rendered
with the navigation links (e.g. `[1, :gap, 7, 8, "9", 10, 11, :gap, 36]`). It accepts an optional `size` keyword argument (only
useful for extras), defaulted on the `:size` variable.

!!!primary Gap: added only when necessary
A `:gap` is added only where the series is missing at least two pages. When the series is missing only one page, the `:gap` is
replaced with the page link of the actual missing page. That's because the page link uses the same space of the `...` gap but it
is more useful.
!!!

The nav helpers basically loop through this array and render the correct item by simply checking its type:

- if the item is an `Integer` then it is a page link
- if the item is a `String` then it is the current page
- if the item is the `:gap` symbol then it is a gap in the series

That is self-contained, simple and efficient.

!!!primary
This method returns an empty array if the `:size` variable is set to `0`. Useful to totally skip the generation of page links in the frontend.

It can also return a simpler array without gaps if the passed `:size` is a single positive `Integer` and the `:ends` variable set to `false`.
!!!

==- `label`

Label for the current page. Its only function in the `Pagy` class is supporting the API of various frontend methods that require
labelling for `Pagy::Calendar` instances. It returns the current page label that will get displayed in the helpers.

==- `label_for(page)`

Label for any page. Its only function in the `Pagy` class is supporting the API of various frontend methods that require labelling
for `Pagy::Calendar` instances. It returns the page label that will get displayed in the helpers.

===

## Variables

All the variables passed to the new method are merged with the `Pagy::DEFAULT` hash and are kept in the object, passed
around with it and accessible through the `pagy.vars` hash.

They can be set globally by using the `Pagy::DEFAULT` hash or passed to the `Pagy.new` method and are accessible through
the `vars` reader.

!!!success
Pagy replaces the blank values of the passed variables with their default values coming from the `Pagy::DEFAULT` hash.
It also applies `to_i` on the values expected to be integers, so you can use values from request `params` without any problem.
For example: `pagy(some_scope, items: params[:items])` will work without any additional cleanup.
!!!

### Variables

The only mandatory instance variable to be passed is the `:count` of the collection to paginate: all the other variables are
optional and have sensible defaults. Of course you will also have to pass the `page` or you will always get the default page
number `1`. For performance reasons, only the instance variables get validated.

| Variable         | Description                                                                                                                                                                           | Default |
|:-----------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------|
| `:count`         | The total count of the collection to paginate (mandatory argument)                                                                                                                    | `nil`   |
| `:count_args`    | The arguments passed to the `collection.count`. You may want to set it to `[]` in ORMs different than ActiveRecord                                                                    | [:all]  |
| `:cycle`         | Enable cycling/circular/infinite pagination: `true` sets `next` to `1` when the current page is the last page                                                                         | `false` |
| `:ends`          | Insert the first and last page into the series, plus the `:gap`s when needed. Ignored with `size < 7`.                                                                                | `7`     |
| `:items`         | The requested number of items for the page                                                                                                                                            | `20`    |
| `:jsonapi`       | Enable `jsonapi` compliance of the pagy query params                                                                                                                                  | `false` |
| `:max_pages`     | Paginate only `:max_pages`. _(see [Paginate only max_pages](/docs/how-to.md#paginate-only-max_pages-regardless-the-count))_                                                           | `nil`   |
| `:outset`        | The initial offset of the collection to paginate: pass it only if the collection had an offset                                                                                        | `0`     |
| `:page`          | The requested page number: extracted from the `request.params`, or forced by passing a variable                                                                                       | `1`     |
| `:page_param`    | The name of the page param name used in the url. _(see [Customize the page param](/docs/how-to.md#customize-the-page-param))_                                                         | `:page` |
| `:params`        | It can be a `Hash` of params to add to the URL, or a `Proc` that can edit/add/delete the request params _(see [Customize the params](/docs/how-to.md#customize-the-params))_          | `nil`   |
| `:request_path`  | Allows overriding the `request.path` for pagination links. Pass the path only (not the absolute url). _(see [Pass the request path](/docs/how-to.md#pass-the-request-path))_          | `nil`   |
| `:size`          | The size of the page links to show _(see also [Control the page links](/docs/how-to.md#control-the-page-links))_                                                                      | `7`     |

!!!
Extras may add and document their own variables
!!!

### Attribute Readers

Pagy exposes all its internal instance variables through a few readers. They all return integers (or `nil`), except the
`vars` hash (which contains all the input variables):

| Reader   | Description                                                                                                        |
|:---------|:-------------------------------------------------------------------------------------------------------------------|
| `count`  | The collection `:count`                                                                                            |
| `from`   | The collection-position of the first item in the page (`:outset` excluded)                                         |
| `in`     | The number of the items in the page                                                                                |
| `items`  | The requested number of items for the page                                                                         |
| `last`   | The number of the last page in the collection (ordinal meaning)                                                    |
| `next`   | The next page number or `nil` if there is no next page                                                             |
| `offset` | The number of items skipped from the collection in order to get the start of the current page (`:outset` included) |
| `page`   | The current page number                                                                                            |
| `pages`  | Alias for `last` (cardinal meaning)                                                                                |
| `prev`   | The previous page number or `nil` if there is no previous page                                                     |
| `to`     | The collection-position of the last item in the page (`:outset` excluded)                                          |
| `vars`   | The variables hash                                                                                                 |

### Lowest limit analysis

The lowest possible limit of the pagination is reached when the collection has `0` count. In that case the Pagy object created has
the following peculiar attributes:

| Attribute | Value   |
|:----------|:--------|
| `count`   | `0`     |
| `page`    | `1`     |
| `last`    | `1`     |
| `in`      | `0`     |
| `from`    | `0`     |
| `to`      | `0`     |
| `prev`    | `nil`   |
| `next`    | `nil`   |
| `series`  | `["1"]` |

Which means:

- there is always a `page` #`1` in the pagination, even if it's empty
- `last` is always at least `1`
- the `series` array contains always at least the page #`1`, which for a single page is also the current page, thus a string.
  With `size: 0` the `series` method returns `[]`
- `in`, `from` and `to` of an empty page are all `0`
- `prev` and `next` of a single page (not necessary an empty one) are both `nil` (i.e. there is no other page)


## Exceptions

==- `Pagy::VariableError`

A subclass of `ArgumentError` that offers a few information for easy exception handling when some of the variable passed to the
constructor is not valid.

```ruby
rescue Pagy::VariableError => e
  e.pagy     #=> the pagy object that raised the exception
  e.variable #=> the offending variable symbol (e.g. :page)
  e.value    #=> the value of the offending variable (e.g -3)
end
```

Mostly useful if you want to rescue from bad user input (e.g. illegal URL manipulation).

==- `Pagy::OverflowError`

A subclass of `Pagy::VariableError`: it is raised when the `:page` variable exceeds the maximum possible value calculated for
the `:count`, i.e. the `:page` variable is in the correct range, but it's not consistent with the current `:count`. That may
happen when the `:count` has been reduced after a page link has been generated (e.g. some record has been just removed from the
DB). See also the [overflow](/docs/extras/overflow.md) extra.

===
