---
order: 100
icon: rocket-24
---

# Quick Start

### 1. Install

:icon-light-bulb: Avoid unexpected breaking changes (see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):

```ruby Gemfile
gem 'pagy', '~> 9.3' # omit patch digit
```

### 2. Use

!!!success Every pagy method is autoloaded on demand

Unused methods consume no memory.
!!!

- Include the `Pagy::Backend`:
  ```ruby ApplicationController/AnyController
  include Pagy::Backend
  ```

- Paginate any collection, with any technique, using the `pagy` paginator method:
  ```ruby Controller Controller/action
  @pagy, @records = pagy(:offset, Product.some_scope, **options)
  ```
  See all the available [paginators](../toolbox/paginator#paginators)

- Render navigator tags and other helpers with the `@pagy` instance methods:

  ```erb
  <%# Render client side nav bar helpers of different types and styles %>
  <%== @pagy.nav_tag %>
  <%== @pagy.nav_js_tag(:bootstrap) %>
  <%== @pagy.combo_nav_js_tag(:bulma) %>
  <%== @pagy.info_tag %>
  ``` 
  See all the available [@pagy methods](../toolbox/instance)

### 3. Configure global options or special features

See [pagy.rb initializer](../toolbox/initializer.md)

#### Pick a stylesheet or a CSS framework

- For native pagy helpers (used also with tailwind), you can integrate the [Pagy Stylesheets](/docs/resources/stylesheet)
- For `:bootstrap` and `:bulma` style you don't need any special CSS file.

#### If you use any `*_js*` method...

Add [Javascript support](../resources/javascript)
