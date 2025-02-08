---
title: Metadata
categories:
- Backend
- Extra
---

# Metadata Extra

Provide the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.

It adds a single method to the backend that you can serve as JSON to your favorite javascript framework.

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/metadata'
```

```ruby Controller (action)
pagy, records = pagy(collection)
render json: { data: records,
               pagy: pagy_data(pagy, ...) }
```

## Variables

| Variable    | Description                                          | Default                                                                                                                                                     |
|:------------|:-----------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `:metadata` | Array of names used to control the returned metadata | `[ :url_template, :first_url, :prev_url, :page_url, :next_url, :last_url, :count, :page, :limit, :opts, :pages, :last, :from, :to, :prev, :next, :series ]` |

As usual, depending on the scope of the customization, you can set the `:metadata` option globally or for a single pagy
instance.

IMPORTANT: Don't rely on the broad default! You should explicitly set the `:metadata` option with only the keys that you will
actually use in the frontend, for obvious performance reasons. Besides you can also add other pagy method names not included in
the default.

### The `:url_template` key

This is a special url string that you can use as the template to build real page urls in your frontend (instead of producing them
on the backend).

It is a pagination url/path (complete with all the params) containing the `"P "` page token in place of the page
number (e.g. `'/foo?page=P &bar=baz'`)

You can generate all the actual links on the frontend by simply replacing the placeholder with the actual page number you want to
link to.

In javascript you can do something like:

```js
pageUrl = urlTemplate.replace("P ", pageNumber)
```

This is particularly useful when you want to build some dynamic pagination UI (e.g. similar to what the `pagy_*combo_js`
generates), but right in your frontend app, saving backend resources with obvious performance benefits.

!!!info `url_template` not necessary for simple cases
For simple cases you might want to use the other few `:*_url` metadata directly, instead of using the `:url_template`.
!!!

## Methods

This extra adds a single method to the `Pagy::Backend` (available in your controllers).

==- `pagy_data(pagy, absolute: nil)`
This method returns a hash with the keys/values defined by the `:metadata` option. When true, the `absolute` boolean argument
will cause all the `:*_url` metadata to be absolute instead of relative.
===
