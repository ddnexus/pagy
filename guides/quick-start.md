#

## :icon-rocket:&nbsp;&nbsp;Quick Start

---

!!!question Migrating from another pagination gem?
Check the [Migration Guide](migration-guide) first
!!!

### Steps

>>> Install it...

```ruby Gemfile
gem 'pagy', '~> 43.5' # MINOR version restriction, to avoid breaking changes
```

>>> Try it...

[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy demo`"](/sandbox/playground/#demo)

>>> Use it...

=== [!badge variant="info" size="s" corners="pill" text="•1"]&nbsp; Include the `pagy` method where you are going to use it _(usually ApplicationController)_:

```ruby
include Pagy::Method
```

=== [!badge variant="info" size="s" corners="pill" text="•2"]&nbsp; Use it to paginate any collection with any technique:

```ruby
@pagy, @records = pagy(:offset, Product.some_scope, **options) # :offset paginator
@pagy, @records = pagy(:keyset, Product.some_scope, **options) # :keyset paginator
@pagy, @records = pagy(...)
```

_Read the [Choose Right](choose-right) guide to pick the right [paginators](/toolbox/paginators#paginators) for your app_

=== [!badge variant="info" size="s" corners="pill" text="•3"]&nbsp; Render navigator tags and other helpers with the `@pagy` instance methods:

```erb
<%# Render navigation bar helpers with various types and styles %>
<%== @pagy.series_nav %>
<%== @pagy.series_nav_js(:bootstrap) %>
<%== @pagy.input_nav_js(:bulma) %>
<%== @pagy.info_tag %>
```
_See all the available [@pagy helpers](/toolbox/helpers)_

===
>>>
