---
label: Quick Start
order: 100
icon: rocket
---

#

## Quick Start

---

### 1. Install

Prevent unexpected breaking changes in stable releases (see [omit the patch version](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):

```ruby Gemfile (stable)
gem 'pagy', '~> 43.2' # Omit the patch segment to avoid breaking changes
```

!!! You can try pagy directly

- **In the Browser**
  - Run `pagy demo` in your terminal, and visit http://127.0.0.1:8000
- **In IRB**
  - Include the [Pagy::Console](../sandbox/console)
!!!

### 2. Use it in your app

- Include the `pagy` method where you are going to use it _(usually ApplicationController)_:
  ```ruby
  include Pagy::Method
  ```
  
- Use it to paginate any collection with any technique:
  ```ruby
  @pagy, @records = pagy(:offset, Product.some_scope, **options) # :offset paginator
  @pagy, @records = pagy(:keyset, Product.some_scope, **options) # :keyset paginator
  @pagy, @records = pagy(...)
  ```
  
  _See all the available [paginators](../toolbox/paginators#paginators)_

- Render navigator tags and other helpers with the `@pagy` instance methods:

  ```erb
  <%# Render navigation bar helpers with various types and styles %>
  <%== @pagy.series_nav %>
  <%== @pagy.series_nav_js(:bootstrap) %>
  <%== @pagy.input_nav_js(:bulma) %>
  <%== @pagy.info_tag %>
  ``` 
  _See all the available [@pagy methods](../toolbox/helpers)_

### 3. Configure global options and special features

- See [pagy.rb initializer](../resources/initializer/)

#### Pick a stylesheet or a CSS framework

- For native pagy helpers you can integrate the [Stylesheets (CSS or Tailwind)](../resources/stylesheets) into your app.
- For `:bootstrap` and `:bulma` styles, no additional CSS file is needed.

#### If you use any `*_js` method...

- Add [JavaScript support](../resources/javascript)
