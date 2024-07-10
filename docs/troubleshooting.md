---
order: 1
title: Troubleshooting
icon: alert-24
---

==- Records may randomly repeat in different pages (or be missing)

!!!danger Don't Paginate Unordered PostgreSQL Collections!

```rb
@pagy, @records = pagy(unordered)

# behind the scenes, pagy selects the page of records with: 
unordered.offset(pagy.offset).limit(pagy.limit)
```

!!!warning From the [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)

When using LIMIT, it is important to use an ORDER BY clause that constrains the result rows into a unique order. Otherwise you
will get an unpredictable subset of the query's rows.
!!!

!!! success Ensure the PostgreSQL collection is ordered!

```rb
# results will be predictable with #order
ordered         = unordered.order(:id)
@pagy, @records = pagy(ordered)
```

!!!

==- Invalid HTML

!!!danger Don't rely on ARIA default with multiple nav elements!
Pagy sets the `aria-label` attribute of its `nav` elements with the translated and pluralized `pagy.aria_label.nav` that finds in
the locale files. That would be (always) `"Page"/"Pages"` for the `en` locale.

Since the `nav` or `role="navigation"` elements of a HTML document are considered `landmark  roles`, they
should be uniquely aria-identified in the page.
!!!

!!!success Pass your own `aria_label` to each nav!

```erb
<%# Explicitly set the aria_label string %> 
<%== pagy_nav(@pagy, aria_label: 'Search result pages') %>
```

!!!
<hr>

!!!danger Don't duplicate attributes with the `:anchor_string`!

```erb
<%== pagy_bootstrap_nav(@pagy, anchor_string: 'class="my-class"', **vars) %>
```

The `class` attribute with a value of `"pagination"` is already added by the `pagy_bootstrap_nav` so it's a duplicate HTML
attribute which is invalid html.
!!!

!!!success Easily check the native component attributes!

```sh
pagy demo
# or: bundle exec pagy demo
# ...and point your browser at http://0.0.0.0:8000
```

!!!primary
In the specific `bootstrap` example you could override the default bootstrap `"pagination"` class by adding other classes with:

```ruby
@pagy, @records = pagy_bootstrap_nav(collection, classes: 'pagination my-class')
```

!!!

==- Slow Last Page

There has been a single report of a slow last page using very big DB tables. It's a pure DB problem and it's not caused by 
pagy or by any other ruby code ([#696](https://github.com/ddnexus/pagy/pull/696), 
[#704](https://github.com/ddnexus/pagy/pull/704)), but a simple pagy override may avoid it:

```rb
## override pagy_get_records
def pagy_get_records(collection, pagy)
  limit = pagy.last == pagy.page ? pagy.in : pagy.items
  collection.offset(pagy.offset).limit(limit)
end
```
!!!
===
