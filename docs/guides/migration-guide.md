---
title: Migrate from other gems
icon: paper-airplane
order: 80
---

# Migrate WillPaginate/Kaminari

This page tries to cover most of the standard changes you will need to make in order to migrate from a legacy pagination.

Feel free to [ask via Pagy Support](https://github.com/ddnexus/pagy/discussions/categories/q-a) if you need help.

## Steps

The Pagy API is quite different from other pagination gems, however, if you split the process in the following general steps it
should be quite simple.

1. Removing the legacy code, trying to convert the statements that have a direct relation with Pagy
2. Running the app so to raise exceptions in order to find legacy code that may still be in place
3. When the app runs without errors, adjusting the pagination to look and work as before: just many times faster and using many
   times less memory

### Removing the old code

#### Preparation

- Replace the legacy gem with `gem "pagy"` in the `Gemfile` and uninstall the legacy gem.
- Add `include Pagy::Backend` statement to the application controller.
- Keep handy both the legacy gem and the pagy docs in parallel.

#### Application-wide search and replace

Search for the class name of the pagination gem to migrate from, for example `WillPaginate` or `Kaminari`. You should find most of
the code relative to global gem configuration, or monkey patching.

Remove all the legacy settings of the old gem.

#### Cleanup the Models

Search for keywords like `per_page`, `per` and such, which are actually configuration settings. They should be added to the
specific paginator call in the controller (e.g. `pagy(:offset, collection, limit: 10)`) or globally to the pagy initializer (e.g.
`Pagy.options[:limit] = 10`)

If the app uses the `page` scope in some of its methods or scopes in some model, that should be removed (including removing the
argument used to pass the page number to the method/scope), leaving the rest of the scope in place. Search where the app uses the
already paginated scope in the controllers, and use the scope in a paginator statement. For example:

```ruby Controller
#@records = Product.paginated_scope(params[:page])
@pagy, @records = pagy(:offset, Product.non_paginated_scope)
```

#### Search and replace in the Controllers

In the controllers, the occurrence of statements from legacy pagination should have a one-to-one relationship with the Pagy
pagination, so you should be able to go through each of them and convert them quite easily.

Search for keywords like `page` and `paginate` statements and use the `pagy(:offset, ...)` paginator instead. For example:

```ruby Controller
#@records = Product.some_scope.page(params[:page])
#@records = Product.paginate(:page => params[:page])

@pagy, @records = pagy(:offset, Product.some_scope)

#@records = Product.some_scope.page(params[:page]).per(15)
#@records = Product.some_scope.page(params[:page]).per_page(15)
#@records = Product.paginate(page: params[:page], per_page: 15)

@pagy, @records = pagy(:offset, Product.all, limit: 15)
```

#### Search and replace in the Views

Also in the views, the occurrence of statements from legacy pagination should have a one-to-one relationship with the Pagy
pagination, so you should be able to go through each of them and convert them quite easily.

Search for keywords like `will_paginate` and `paginate` statement and use one of the `nav_tag` methods. For example:

```erb View
<%= will_paginate @records %>
<%= paginate @records %>

<%== @pagy.nav_tag %>
```

## Find the remaining code

If the app has tests it's time to run them. If not, start the app and navigate through its pages.

If anything of the old code is still in place you should get some exception. In that case, just remove the old code and retry
until there will be no exception.

## Fine-tuning

If the app is working and displays the pagination, it's time to adjust Pagy as you need. However, if the old pagination was using
custom elements (e.g. custom params, urls, links, html elements, etc.) it will likely not work without some possibly easy
adjustment.

Please take a look at the topics in the [how-to](how-to.md) documentation: that should cover most of your custom needs.

### CSS

The css styling that you may have applied to the pagination elements may need some minor change. However, if the app uses the
pagination from bootstrap (or some other framework), the same CSSs should work seamlessly with the pagy nav helpers.
