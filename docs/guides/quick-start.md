---
order: 100
icon: rocket
---

# Quick Start

### 1. Install

:icon-light-bulb: To prevent unexpected breaking changes, see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint):

```ruby Gemfile
gem 'pagy', '~> 9.3' # omit the patch version
```

### 2. Use

- Include the `pagy` method:
  ```ruby ApplicationController/AnyController
  include Pagy::Method
  ``` 

- Use it to paginate any collection with any technique:
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
  <%# Render client-side navigation bar helpers with various types and styles %>
  <%== @pagy.nav_tag %>
  <%== @pagy.nav_js_tag(:bootstrap) %>
  <%== @pagy.combo_nav_js_tag(:bulma) %>
  <%== @pagy.info_tag %>
  ``` 
  See all the available [@pagy methods](../toolbox/methods)

### 3. Configure global options and special features

- See [pagy.rb initializer](../toolbox/initializer.md)

#### Pick a stylesheet or a CSS framework

- For native pagy helpers (used also with tailwind), you can integrate the [Pagy Stylesheets](../resources/stylesheet)
- For `:bootstrap` and `:bulma` styles, no additional CSS file is needed.

#### If you use any `*_js*` method...

- Add [JavaScript support](../resources/javascript)
