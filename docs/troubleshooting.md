---
order: 7
title: Troubleshooting
icon: alert-24
---


### Non-idempotent Results with PostgreSQL

!!! Warning Without `order`

...pagination results may vary (i.e page `x` may show different records every time).

```rb
@pagy, @records = pagy(Product.some_scope)

# the "pagy" method translates the above into the following: 
Product.some_scope.offset(_).limit(_) # 'limit' is called
```

Why? When PosgtreSQL uses `limit` without an `ORDER BY` clause - [the results may not be ordered in the same way](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY) each time a query is run. If this is a [critical issue](https://github.com/ddnexus/pagy/issues/306) for your app, ensure you order your scope by a particular column.
!!!


!!! success
For consistent results (with PostgreSQL) use `order`.

```rb
@pagy, @records = pagy(Product.some_scope.order(:id)) # results will be predictable (order by id)
```
!!!