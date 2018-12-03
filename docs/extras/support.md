---
title: Support
---
# Support Extra

This extra adds support for features like countless or navless pagination, where you don't need the full link bar but only a simple `next` or `prev` link or no link at all (like for auto-scroll).

It also provides a couple of helpers to setup you own custom javascript components.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/support'
```

## Support for alternative pagination types and features

Besides the classic navbar pagination, the `compact` and the `responsive` UI components, Pagy offers a few helpers to support a few alternative types of pagination and related features.

### Countless

You can totally avoid one query per render by using the [countless](countless.md) extra. It has a few limitation, but still supports navbar links (see also [Pagy::Countless](../api/countless.md) for more details).

### Navless/incremental

If you don't need the navbar you can just set the `:size` variable to an empty value and the page links will be skipped from the rendering. That works with `Pagy` and `Pagy:Countless` instances. All the `*nav` helpers will render only the `prev` and `next` links/buttons, allowing for a manual incremental pagination.

You can also use the `pagy_prev_link` and `pagy_next_link` helpers provided by this extra, mostly useful if you also use the `countless` extra.

### Circular/Infinite

This type of pagination sets the `next` page to `1` when the current page is the last page, allowing an infinite loop through the pages.

For example, it is often used to show a few suggestions of "similar products" in a horizontal stripe of just a few page of a few items each. Clicking on next will continue to loop through.

For example:

```ruby
@pagy, @suggestions = Pagy.new(count: 25, items: 5, cycle: true)
```

Passing a forced `:count` of 25 will generate 5 pages of 5 items each that will always have a next page. Regardless the actual collection count, you will show the first 25 items of the collection, looping in stripes of 5 items each.

You may want to combine it with something like:

```erb
<%== pagy_next_link(@pagy, 'More...')
```

### Auto-scroll

Pagy supports auto-scroll pagination by providing the `pagy_apply_init_tag` helper, which initializes your custom pagination elements by calling your custom defined javascript function at page load.

### Custom UIs

You can use the `pagy_prev_url` and `pagy_next_url` to build your own links or buttons. Besides, with the `pagy_apply_init_tag` and `pagy_serialized` helpers you can also setup you own custom javascript components.

## Methods

### pagy_prev_url(pagy)

Returns the url for the previous page. Useful to build minimalistic UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_next_url(pagy)

Returns the url for the next page. Useful to build minimalistic UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_prev_link(pagy, text=pagy_t('pagy.nav.prev'), link_extra='')

Returns the link for the next page. It is the same prev link string which is part of the `pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_next_link(pagy, text=pagy_t('pagy.nav.next'), link_extra='')

Returns the link for the next page. It is the same next link string which is part of the `pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_serialized(pagy)

Returns a hash with all the instance variables, series, prev_url and next_url of the `pagy` argument. Useful to use in some client-side javascript. It's the default payload of `pagy_apply_init_tag`.

### pagy_apply_init_tag(pagy, function, payload=...)

This is a multi-purpose helper that generates a JSON tag that will be loaded and exececuted by the `Pagy.init` javascript function at document load (see [Javascript](../extras.md#javascript)).

The method requires a pagy object, a javascript function name and accepts an optional payload (default to the hash returned by `pagy_serialized` method) that will get passed to the function. For example:

```ryby
# this uses the serialized pagy object as the default payload
pagy_apply_init_tag(@pagy, :myInitFunction)

# this uses a custom payload
pagy_apply_init_tag(@pagy, :myOtherFunction, {a: 1, b: 2})
```

You should define your functions in the `PagyInit` namespace, as follow, using the payload as needed:

```javascript
PagyInit.myInitFunction = function(payload){
  console.log(payload);
  doSomethingWith(payload);
  ...
}
```

You can use it to initialize your custom pagination elements. For auto-scroll, you may want to update some client side variable with the `pagy_next_url` at each page load.
