---
title: Metadata
category: Backend Extras
---
# Metadata Extra

If your app uses ruby as pure backend and some javascript frameworks as the frontend (e.g. Vue.js, react.js, ...), then you may want to generate the whole pagination UI directly in javascript either with your own code or using some available component.

This extra makes that easy and efficient by adding a single method to the backend that you can serve as JSON to your favorite javascript framework.

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/metadata'
```

In your controller action:

```ruby
pagy, records = pagy(Product.all)
render json: { data: records,
               pagy: pagy_metadata(pagy, ...) }
```

## Files

- [metadata.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/metadata.rb)

## Variables

| Variable    | Description                                          | Default                                                                                                                                                     |
|:------------|:-----------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `:metadata` | Array of names used to control the returned metadata | `[ :scaffold_url, :first_url, :prev_url, :page_url, :next_url, :last_url, :count, :page, :items, :vars, :pages, :last, :from, :to, :prev, :next, :series ]` |

As usual, depending on the scope of the customization, you can set the `:metadata` variable globally or for a single pagy instance. 

IMPORTANT: Don't rely on the broad default! You should explicitly set the `:metadata` variable with only the keys that you will actually use in the frontend, for obvious performance reasons. Besides you can also add other pagy method names not included in the default. 

### :scaffold_url key

This is a special url string that you can use as the scaffold to build real page urls in your frontend (instead of producing them on the backend).

It is a pagination url/path (complete with all the params) containing the `__pagy_page__` placeholder in place of the page number (e.g. `'/foo?page=__pagy_page__&bar=baz'`)

You can generate all the actual links on the frontend by simply replacing the placeholder with the actual page number you want to link to.

In javascript you can do something like:

```js
page_url = scaffold_url.replace(/__pagy_page__/, page_number)
```

This is particularly useful when you want to build some dynamic pagination UI (e.g. similar to what the `pagy_*combo_js` generates), but right in your frontend app, saving backend resources with obvious performance benefits.

**Notice**: for simple cases you might want to use the other few `:*_url` metadata directly, instead of using the `:scaffold_url`.

## Methods

This extra adds a single method to the `Pagy::Backend` (available in your controllers).

### pagy_metadata(pagy, absolute: nil)

This method returns a hash with the keys/values defined by the `:metadata` variable.  When true, the `absolute` boolean argument will cause all the `:*_url` metadata to be absolute instead of relative.
