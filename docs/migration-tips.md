---
title: Migration Tips
---
# Migration Tips

This page tries to cover most of the standard changes you will need to make in order to to migrate from a legacy pagination, however, if the legacy pagination is higly customized you may need more digging into the Pagy documentation.

Feel free to [ask on Gitter](https://gitter.im/ruby-pagy/Lobby) if you need more assistance.

## Phases

The Pagy API is quite different from other pagination gems, so there is not always a one-to-one correlation between the changes you will have to make, however, if you split the process in the following general phases it should be quite simple.

1. Removing the legacy code, trying to convert the statements that have a direct relation with Pagy
2. Running the app so to raise exceptions in order to find legacy code that may be still in place
3. When the app runs without error, adjusting the pagination to look and work as before: just many times faster and using many times less memory ;)

### Removing the old code

In this phase you will search statements from legacy pagination gems, remove them and possibly write the equivalent Pagy statements if that makes sense for Pagy:

- If it makes sense, you should add the equivalent Pagy statement and remove the legacy statement(s).
- If it doesn't make sense, then just remove the legacy statement.

**Notice:** Don't worry about missing something in this phase: if anything wont work as before you can fix it later in the process.

#### Preparation

- Copy the content of the [initializer_example.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) and rename it `pagy.rb`: you will edit it during the process.
- Replace the legacy gem with `gem "pagy"` in the `Gemfile` and `bundle`, or install and require the gem if you don't use bundler.
- Ensure that the legacy gem will not get loaded anymore (or it could mask some old statement still in place and not converted)
- Add the `include Pagy::Backend` statement to the application controller.
- Add the `include Pagy::Frontend` statement to the application helper.
- Keep handy the legacy gem doc and the [Pagy API doc](api/pagy.md) in parallel.

#### Application-wide search and replace

Search for the class name of the pagination gem to migrate from, for example `WillPaginate` or `Kaminari`. You should find most of the code relative to global gem configuration, or monkey patching.

For example, the following configuration are equivalent:

```ruby
WillPaginate.per_page = 10
WillPaginate::ViewHelpers.pagination_options[:inner_window] = 4
WillPaginate::ViewHelpers.pagination_options[:outer_window] = 5
```

```ruby
Kaminari.configure do |config|
  config.max_per_page = 10
  config.window = 4
  config.outer_window = 5
  #config.left = 0
  #config.right = 0
end
```

```ruby
Pagy::VARS[:items] = 10
Pagy::Vars[:size]  = [5,4,4,5]
```

Remove all the old settings and uncomment and edit the new settings in the `pagy.rb` initializer.

#### Cleanup the Models

One of the most noticeable difference between the legacy gems and Pagy is that Pagy doesn't mess at all with the models (read the reasons [here](index.md#stay-away-from-the-models)).

The other gems are careless about adding methods, scopes, and even configuration settings to them, so you will find different kinds of statements scattered around in your models. You should remove them all and eventually add the equivalent code where it makes sense to Pagy, which of course _is absolutely not_ in the models.

For example, you may want to search for keywords like `per_page`, `per` and such, which are actually configuration settings. They should either go into the Pagy initializer (if they are global to the app) or into the specific `pagy` call in the controller if they are specific to an action.

If the app used the `page` scope in some of its methods or scopes, that should be removed (including removing the argument used to pass the page number to the scope), leaving the rest of the scope in place. Search where the app uses the already paginated scope in the controllers, and use the scope in a regular `pagy` statement. For example:

```ruby
#@records = Product.paginated_scope(params[:page])
@pagy, @records = pagy(Product.non_paginated_scope)
```

#### Search and replace in the Controllers

In the controllers, the occurency of statements from legacy pagination should have a one-to-one relationship with the Pagy pagination, so you should be able to go through each of them and convert them quite easily.

Search for keywords like `page` and `paginate` statements and use the `pagy` method instead. For example:

```ruby
#@records = Product.some_scope.page(params[:page])
#@records = Product.paginate(:page => params[:page])

@pagy, @records = pagy(Product.some_scope)
```

```ruby
#@records = Product.some_scope.page(params[:page]).per(15)
#@records = Product.some_scope.page(params[:page]).per_page(15)
#@records = Product.paginate(page: params[:page], per_page: 15)

@pagy, @records = pagy(Product.some_scope, items: 15)
```

#### Search and replace in the Views

Also in the views, the occurency of statements from legacy pagination should have a one-to-one relationship with the Pagy pagination, so you should be able to go through each of them and convert them quite easily.

Search for keywords like `will_paginate` and `paginate` statement and use one of the `pagy_nav` methods. For example:

```erb
<%= will_paginate @records %>
<%= paginate @records %>

<%== pagy_nav @pagy %>
```

## Find the remaining code

If the app has tests it's time to run them. If not, start the app and navigate through its pages.

If anything of the old code is still in place you should get some exception. In that case, just remove the old code and retry until there will be no exception.

## Fine tuning

If the app is working and displays the pagination, it's time to adjust Pagy as you need, but if the old pagination was using custom items (e.g. custom params, urls, links, html elements, etc.) it will likely not work without some possibly easy adjustment.

Please take a look at the topics in the [how-to](how-to.md) documentation: that should cover most of your custom needs.

### CSSs

If the app uses the bootstrap pagination, the same CSSs should work seamlessly with `pagy_nav_bootstrap` or with any of the bootstrap templates. If the app doesn't use bootstrap, you may need to rename some rule in your CSSs.

### I18n

If the app uses `I18n` you should copy and paste the entries in the [pagy.yml dictionary file](https://github.com/ddnexus/pagy/blob/master/lib/locales/pagy.yml) to the dictionaries of your app, and translate them accordingly.

See also [I18n](api/frontend.md#i18n).
