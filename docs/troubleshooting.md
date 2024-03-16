---
order: 7
title: Troubleshooting
icon: alert-24
---

### Records may randomly repeat in different pages (or be missing)

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
ordered = unordered.order(:id)
@pagy, @records = pagy(ordered)
```

!!!
