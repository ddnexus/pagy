---
title: Pagy::KeysetForUI
category:
  - Feature
  - Class
---

# Pagy::KeysetForUI

A [Pagy::Keyset](keyset.md) subclass supporting `pagy_*nav` and other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

## Overview

The regular `Pagy::Keyset` uses the fastest technique for SQL pagination, but it cannot work with any Frontend helper because they
require a pagy object with numeric variables.

That's why we created `Pagy::KeysetForUI`: it uses the fast keyset pagination AND supports `pagy_*navs` and other Frontend
helpers.

!!!
The API is documented here, however you should use the [keyset_for_ui extra](/docs/extras/keyset_for_ui.md)
wrapper to handle the client `storageSession` cache automatically and easily integrate it with your app.

You should also familiarize with the [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Glossary

This section integrates the [Keyset Glossary](keyset_for_ui.md#glossary)

| Term                       | Description                                                                                                                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `keyset pagination for UI` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and other Frontend helpers.<br/>The best technique for performance AND functionality! |
| `page`                     | The array of variables from the client prepared by the `keyset_for_ui` extra, to paginate the requested page.                                                                             |
| `cutoffs`                  | The array of `cutoff`s of the known pagination state, used to keep track of the visited pages during the navigation. They are cached in the `sessionStorge` of the client.                |

## How Pagy Keyset For UI works

The Keyset pagination for UI adds the numeric variables (`page`, `last`, `prev`, `next`, `in`) to its instances, supporting their
usage with most Frontend helpers. It does so by transparently exchanging data back and forth with the client, that stores the
state of the pagination.

You can use a `Pagy::KeysetForUI` object as you would with a standard `Pagy` (offset countless) object. You need just a different
setup and you will get a lot more performance.

==- In-depth: Understanding the data exchange
<br/>

### The `data-pagy` Attribute

<br/>

The `data-pagy` attribute encodes all the variables needed for the client. Pagy already uses it for every `*_js` helpers. The
keyset communication adds an extra array of variables that will be used by the javascript function to:

1. Create, update the `cutoffs` array in the `sessionStorage` (when a new page has been visited).
2. Augment the `page` param value in the url of the page anchors.

### The Cutoffs Storage

<br/>

When a user requests a new page, its `cutoff` is generated and added to the `data-pagy` HTML attribute of the generated `nav`
element, and the small `Pagy.init` javascript function (running on the client) adds it to the `cutoffs` array of the current
pagination, which are stored in the browser `sessionStorage`.

In case the client is an old Browser that doesn't implement the `sessionStorage` or the `BroadcastChannel` API, the pagination
will not fail: the `page` params will remain numbers, so the pagination will just transparently fall back to OFFSET pagination,
using `pagy_countless` instead of `pagy_keyset_for_ui`.

### The Page Augmentation

<br/>

The `nav` helpers are served with numeric pages in the URLs (e.g. `/?page=1`, `/?page=2`, `/?page=3`, ...), because they are a
guessable series. However, the keyset pagination requires `cutoff` pages in the URLs (e.g. `/?`, `/?page=WzEwXQ`,
`/?page=WzIwXQ`, ...), and that is not guessable. With pure Keyset pagination you have no idea which `cutoff` will be required for
page n, nor if that page even exist.

In order to work around this problem, each time Pagy dicovers a new `cutoff`, it stores it in the `cutoffs` array on the client
side. That way the `cutoff` of a numeric page is accessed by simply using its numeric index.

Then the server can just supply the page `number` in the links, and the client will replace the page param numbers with the
`cutoff` stored for each page.

!!!

The client will actually set the `page` param value of each URL to an array of variables, in order to provide the complete state
of the `page` that will be requested with that particular URL.
!!!

### Handling the Request

<br/>

The [keyset_for_ui extra](/docs/extras/keyset_for_ui.md) is responsible for decoding and checking the variables, passing them to
this class or falling back to the `pagy_countless` constructor if the client side does not suport the
`sessionStorage`.

When the controller action runs, the `pagy_keyset_for_ui` checks the `page` request param:

- If it's a `Number`, then the browser failed to augment the `page`, so it transparently calls `pagy_countless` to provide a
  suitable object to pass to the helpers.
- If it's a `String`, then it decodes it into the array of the variables passed by the client, it checks a few things and passes
  it to this class.
- If it's `nil` it's the start of a new pagination cycle

===

==- In-depth: Filtering between Cutoffs

Let's take a new look at the diagram of the keyset pagination explained in
the [Keyset documentation](/docs/api/keyset.md#understanding-the-cutoffs):

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

Let's suppose that we navigate till page #3 (i.e. the last page), and we click on the link for page #2. We have stored the
`cutoff-X`, so we can pull again the 10 records after `cutoff-X` as we did the first time... but are we sure that we would get the
same results?

Let's suppose that the database just changed: 1 inserted records before `cutoff-X`, and 2 deleted records after the `cutoff-X`...

```
                  │ page #1 (11)       >│ page #2 (8)  >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · · X]· · · · · · · Y]· · · · · · · · ·]< end of set
                                        ▲               ▲
                                   cutoff-X        cutoff-Y
```

At this point pulling 10 records from the `cutoff-X` would get also the first 2 records from page 3, if you navigate on page 3 you
will pull the same 2 records again also for page #3.

Indeed, not only the results have changed, but the cutoffs appear to have also shifted their absolute position in the set. In
reality the cutoffs have the same value as before, so they maintaied their relative position in the set, so now there is a
different number of records falling into the same pages, which is totally consistent with the changes, but possibly unespected if
you have the mindset of OFFSET pagination, where the pages are split by number of records (absolute position) and not by their
position relative to the set.

!!!

The main goal of pagination is splitting the results in manageable chunks and possibly be fast and accurate, so the variation on
the page size seems not relevant to that. However, should it be relevant to you, you can always use the classic OFFSET pagination
and accept its slowness and inaccuracy.
!!!

So pagy don't use the LIMIT to pull the records of already visited pages. It replaces the LIMIT with the same filter used for the
`beginning` of the page, but it just combines it with the negated filter of the `ending` of the page.

For example, the filtering of the page could be logically described like:

```
- Page #1 `WHERE NOT AFTER CUTOFF-X`                    <- only ending filter
- Page #2 `WHERE AFTER CUTOFF-X AND NOT AFTER CUTOFF-Y` <- combined beginning + ending filter
- Page #3 `WHERE AFTER CUTOFF-Y LIMIT 10`               <- regular beginning filter (no cutoff for last page)
```

!!!success We plan to implement page-rebalancing:

When the number of records of a visited page have drastically changed, it would be nice to mitigate the surprise effect on the
user by:

- Automatically compacting the empty (or almost empty) visited pages.
- Automatically splitting the eccesively grown visited pages.
!!!

===

## Setup

- See the [Keyset Setup](keyset.md#setup)
- You need also to [Setup Javascript](/docs/api/javascript/setup.mdS)

## ORMs

`Pagy::KeysetForUI` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them
internally:

```ruby
Pagy::KeysetForUI.new(active_record_set)
#=> #<Pagy::KeysetForUI::ActiveRecord:0x00000001066215e0>

Pagy::KeysetForUI.new(sequel_set)
#=> #<Pagy::KeysetForUI::Sequel:0x00000001066545e0>
```

## Methods

==- `Pagy::KeysetForUI.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a
`Pagy::KeysetForUI::ActiveRecord` or
`Pagy::KeysetForUI::Sequel` object (depending on the `set` class).

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

This section ontegrates the [Pagy::Keyset variables](keyset.md#variables):

==- `:page`

The array of variables from the client prepared by the `keyset_for_ui` extra, to paginate the requested page.

==- `:max_pages`

Paginate only `:max_pages` ignoring the rest.

===

## Attribute Readers

`in`, `last`, `next`, `page` (number), `prev`, `vars`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#troubleshooting)
