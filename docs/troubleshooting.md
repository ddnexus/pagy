---
order: 7
title: Troubleshooting
icon: alert-24
---

### Records may randomly repeat in different pages (or be missing)

!!!danger Unordered PostgreSQL Collections!

```rb
@pagy, @records = pagy(collection)

# behind the scene, pagy selects the page of records by doing: 
collection.offset(_).limit(_)
```
!!!warning From [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)

When using LIMIT, it is important to use an ORDER BY clause that constrains the result rows into a unique order. Otherwise you
will get an unpredictable subset of the query's rows.
!!!

!!! success Use `order` with PostgreSQL collections!

```rb
# results will be predictable (order by id)
@pagy, @records = pagy(collection.order(:id))
```

!!!
