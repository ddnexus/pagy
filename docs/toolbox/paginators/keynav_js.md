---
label: :keynav_js
icon: list-ordered
order: 80
categories:
  - Paginators
---

#

## :icon-list-ordered: :keynav_js

---

`:keynav_js` is a fast KEYSET paginator that supports the UI. It's a pagy exclusive technique.

- It requires [JavaScript Support](../../resources/javascript.md) and a browser that implements `sessionStorage` _(largely supported by all browsers nowaday)_.
  - If those conditions are not met, it falls back to the [:countless](countless.md) paginator seamlessly.
    :::

```ruby Controller 
@pagy, @records = pagy(:keynav_js, collection, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [instance methods](../methods#methods) to use in your code.
- `@records` is the eager-loaded `Array` of the page records.

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#5-keyset-apps)

!!!warning This documentation integrates the [:keyset](keyset.md) documentation.

It's easier to understand if you familiarize with the [:keyset](keyset.md) docs.
!!!

==- Readers

See also [Keyset Readers](keyset#readers)


==- Glossary

Integrates the [Keyset Glossary](keyset#glossary)

{ .compact }

| Term                | Description                                                                                                                                                                 |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `keynav pagination` | The pagy exclusive technique to use `keyset` pagination, providing **nearly complete** support for **most** navigation helpers. The fasted technique with UI capabilities.  |
| `page`              | The array of options from the client prepared by the `keynav_js`, to paginate the requested page.                                                                           |
| `cutoffs`           | The array of `cutoff`s of the known pagination state, used to keep track of the visited pages during the navigation. They are cached in the `sessionStorage` of the client. |

==- How it works

The Keynav pagination adds the numeric variables (`@page`, `@last`, `@prev`, `@next`, `@in`) to its instances, supporting their usage
with the UI. It does so by transparently exchanging data with the client, that stores the state of the pagination.

You can use the `:keyset_js` paginator as you would use the [:countless paginator](countless.md). You just need
the [Keyset Setup](keyset#setup) and [JavaScript Support](../../resources/javascript.md), to get a lot more performance.

==- In-depth: Cutoffs Filtering

Let's take a new look at the diagram of the keyset pagination explained in the [Keyset documentation](keyset#in-depth-cutoffs):

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

Let's suppose that we navigate till page #3 (i.e. the last page), and we click on the link for page #2. We have stored the
`cutoff-X`, so we can pull the 10 records after `cutoff-X` again as we did the first time... but are we sure that we would get the
same results?

Let's suppose that the database just changed: 1 record was inserted before `cutoff-X`, and 2 records were deleted after
`cutoff-X`...

```
                  │ page #1 (11)       >│ page #2 (8)  >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · · X]· · · · · · · Y]· · · · · · · · ·]< end of set
                                        ▲               ▲
                                   cutoff-X        cutoff-Y
```

At this point pulling 10 records from the `cutoff-X` would get also the first 2 records from page 3, if you navigate on page 3 you
will pull the same 2 records again also for page #3.

Indeed, not only the results have changed, but the cutoffs appear to have also shifted their absolute position in the set. In
reality the cutoffs have the same value as before, so they maintained their relative position in the set, and now there is a
different number of records falling into the same pages, which is totally consistent with the changes, but possibly unespected if
you have the mindset of OFFSET pagination, where the pages are split by number of records (absolute position) and not by their
position relative to the records in the set.

!!!
The main goal of pagination is to split the results into manageable chunks and ensure it is as fast and accurate as possible, so
the variation in the page size seems not relevant to that. However, should it be relevant to you, you can always use the classic
OFFSET pagination and accept its slowness and inaccuracy.
!!!

Pagy doesn't use the LIMIT to pull the records of already visited pages. Instead, it replaces the LIMIT with the same filter used
for the
`beginning` of the page, but it just compounds it with the negated filter of the `ending` of the page.

For example, the filtering of the page could be logically described like:

```
- Page #1 `WHERE NOT AFTER CUTOFF-X`                    <- only ending filter
- Page #2 `WHERE AFTER CUTOFF-X AND NOT AFTER CUTOFF-Y` <- combined beginning + ending filter
- Page #3 `WHERE AFTER CUTOFF-Y LIMIT 10`               <- regular beginning filter (no cutoff for last page)
```

!!! Implementing page-rebalancing:

When the number of records on a visited page has drastically changed, it would be helpful to mitigate the surprise effect on the
user by:

- Automatically compacting the empty (or almost empty) visited pages.
- Automatically splitting the excessively grown visited pages.
  !!!

==- Caveat

Nav bar links beyond the last or highest visited page are not displayed.

===
