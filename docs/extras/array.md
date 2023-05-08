---
title: Array
categories:
- Backend
- Extra
---

# Array Extra

Paginate arrays efficiently.

!!! warning WARNING
The `array` extra is efficient if you need to paginate an array, but if the data in the array comes from some DB or other persisted storage (i.e. not some in-memory storage), DO NOT use the array extra.
!!!

+++ Bad
!!!danger Do not:
```rb
def index 
    @pagy, @comments = pagy_array(Comment.all.to_a) # no! wasting memory
end
```
There is no need to use `pagy_array` extra here because we are retrieving from a database.

Do this instead:
```rb
# good
def index 
    @pagy, @comments = pagy(Comment.all) # pagy method, instead of pagy_array
end
```

!!!

+++ Good
!!!success DO:
```rb
def index 
    @pagy, @special_items = pagy_array([1,2,3,4]) # items not retrieved from DB.
end
```
Use only if you are not retrieving from a database.

+++





## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/array'
```
|||

||| Controller
```ruby
@pagy, @items = pagy_array(an_array, ...)
```
|||

## Files

- [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb)

## Methods

==- `pagy_array(array, vars=nil)`

This method is the same as the generic `pagy` method, but specialized for an Array. (see the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil))

==- `pagy_array_get_vars(array)`

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_array` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

===
