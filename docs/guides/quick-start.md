---
order: 100
icon: rocket
---

# Quick Start

### 1. Install

:icon-light-bulb: Avoid unexpected breaking changes (see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):

```ruby Gemfile
gem 'pagy', '~> 9.3' # omit patch digit
```

### 2. Use

- Include the `pagy` method:
  ```ruby ApplicationController/AnyController
  include Pagy::Method
  ``` 

- Now, you can use it to paginate ANY collection, with ANY technique:
  ```ruby Controller Controller/action
  @pagy, @records = pagy(:offset, Product.some_scope, **options) # :offset paginator
   @pagy, @records = pagy(:keyset, Product.some_scope, **options) # :keyset paginator
   ...
  ```
  
  !!!success The `pagy` method autoloads paginators on demand

  Unused code consumes no memory.
  !!!
  
  See all the available [paginators](../toolbox/paginators#paginators)

- Render navigator tags and other helpers with the `@pagy` instance methods:

  ```erb
  <%# Render client side nav bar helpers of different types and styles %>
  <%== @pagy.nav_tag %>
  <%== @pagy.nav_js_tag(:bootstrap) %>
  <%== @pagy.combo_nav_js_tag(:bulma) %>
  <%== @pagy.info_tag %>
  ``` 
  See all the available [@pagy methods](../toolbox/methods)

### 3. Configure global options or special features

- See [pagy.rb initializer](../toolbox/initializer.md)

#### Pick a stylesheet or a CSS framework

- For native pagy helpers (used also with tailwind), you can integrate the [Pagy Stylesheets](../resources/stylesheet)
- For `:bootstrap` and `:bulma` style you don't need any special CSS file.

#### If you use any `*_js*` method...

- Add [Javascript support](../resources/javascript)
