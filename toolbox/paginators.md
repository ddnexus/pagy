#

## ✳&nbsp;&nbsp;Paginators

||| The `pagy` Method

The `pagy` method provides a common interface to all paginators. Include it where you are going to paginate a collection _(usually in ApplicationController)_:

```ruby
include Pagy::Method
```
You can use it to paginate ANY collection, with ANY technique. For example:

```ruby
@pagy, @records = pagy(:offset, collection, **options)
@pagy, @records = pagy(:keyset, set, **options)
@pagy, @records = pagy(...)
```

- `:offset`, `:keyset`, etc. are symbols identifying the [paginator](#paginators). They implement the specific pagination.
- `@pagy` is the pagination instance. It provides all the instance helper methods to use in your code.
- `@records` are the records belonging to the requested page.

!!!info
The `pagy` method expects to find the rack request at `self.request`, however, you can also use pagy [outside controllers or views](/guides/how-to/#use-pagy-outside-controllers-or-views), or pass your own `:request` option.
!!!

|||

### Paginators

!!!tip Read also the [Choose Right Guide](/guides/choose-right.md) to ensure good performance and smooth workflow.
!!!

The `paginators` are symbolic names of different pagination types/contexts (e.g., `:offset`, `:keyset`, `countless`, etc.). You pass the name to the `pagy` method and pagy will internally instantiate and handle the appropriate paginator class.

!!!warning Avoid instantiating Pagy classes directly
Instantiate paginator classes only if the documentation explicitly suggests it.
!!!

!!!success Paginators and classes are autoloaded only if used!
Unused code consumes no memory.
!!!

==- :icon-stop:&nbsp; Troubleshooting

:::
==- Records may repeat in different pages or be missing

||| :icon-question: Unordered PostgreSQL collection

PostgreSQL collections must be ordered.

||| :icon-check-circle: Solutions

Chain something like `.order(:id)` to your collection. _See the [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)_

|||
:::
===
