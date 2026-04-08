#

## :icon-paper-airplane:&nbsp;&nbsp;Migrate WillPaginate/Kaminari

---

This page tries to cover most of the standard changes you will need to make in order to migrate from legacy pagination.

### Steps

The Pagy API is quite different from other pagination gems, however, if you split the process in the following general steps it should be quite simple.

>>> Remove the old code

==- [!badge variant="info" size="s" corners="pill" text="•1"]&nbsp; Preparation

- Uninstall the legacy gem and replace it with `gem "pagy"` in the `Gemfile`.
- Add `include Pagy::Method` statement to the application controller.

==- [!badge variant="info" size="s" corners="pill" text="•2"]&nbsp; Application-wide search and replace

- Search for the class name of the legacy gem, for example `WillPaginate` or `Kaminari`. You should find most of the code relative to global gem configuration or monkey patching.
- Remove all the legacy settings of the old gem.

==- [!badge variant="info" size="s" corners="pill" text="•3"]&nbsp; Cleanup the Models

Look for terms like `per_page`, `per`, and similar, as these are configuration settings. Include them in the appropriate paginator call in the controller (e.g., `pagy(:offset, collection, limit: 10)`) or globally in the Pagy initializer (e.g., `Pagy::OPTIONS[:limit] = 10`).

If the app uses the `page` scope in model methods or scopes, remove it, along with the argument used to pass the page number, while preserving the rest of the scope. Locate where the app applies this paginated scope in the controllers and replace it with the scope in a paginator statement. For example:

```ruby Controller
#@records = Product.paginated_scope(params[:page])
@pagy, @records = pagy(:offset, Product.non_paginated_scope)
```

==- [!badge variant="info" size="s" corners="pill" text="•4"]&nbsp; Search and replace in the Controllers

In controllers, legacy pagination statements generally map directly to Pagy, making them straightforward to convert.

Search for keywords like `page` and `paginate` statements and use the `pagy(:offset, ...)` paginator instead. For example:

```ruby Controller
#@records = Product.some_scope.page(params[:page])
#@records = Product.paginate(:page => params[:page])

@pagy, @records = pagy(:offset, Product.my_scope)

#@records = Product.some_scope.page(params[:page]).per(15)
#@records = Product.some_scope.page(params[:page]).per_page(15)
#@records = Product.paginate(page: params[:page], per_page: 15)

@pagy, @records = pagy(:offset, Product.all, limit: 15)
```

==- [!badge variant="info" size="s" corners="pill" text="•5"]&nbsp; Search and replace in the Views

Similarly, in views, legacy pagination statements typically correspond directly to Pagy, simplifying conversion.

Search for keywords like `will_paginate` and `paginate` statement and use one of the `series_nav` methods. For example:

```erb View
<%= will_paginate @records %>
<%= paginate @records %>

<%== @pagy.series_nav %>
```
===

>>> Find the remaining code

If the app has tests, it's time to run them. If not, start the app and navigate through its pages.

If any legacy code remains, it will raise an exception. Remove the old code and retry until no exceptions occur.

>>> Fine-tuning

Once the app displays pagination correctly, customize Pagy as needed _(see [Stylesheets](/resources/stylesheets))_.

If the previous pagination used custom elements (e.g., custom params, URLs, links, HTML elements, etc.), adjustments may be required for compatibility. Please take a look at the topics in the [How To](how-to) docs: that should cover most of your custom needs.

!!!tip
If the app uses pagination from `Bootstrap` or `Bulma` frameworks, the existing CSS should function seamlessly with Pagy navigation helpers.
!!!
>>>

!!!question

Feel free to ask for further help via [Pagy Support](https://github.com/ddnexus/pagy/discussions/categories/q-a).

!!!
