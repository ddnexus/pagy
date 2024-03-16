---
order: 4
icon: rocket-24
---

# Quick Start

=== If you want to just try Pagy before using it in your own app, you have a couple of alternatives...

+++ Pagy Application

Ensure to have `rack` installed (or `gem install rack`)

Download and run any of the following self contained file:

[!file](/apps/pagy_styles.ru)

+++ Pagy Console

||| Install the gem

```sh
gem install pagy
```

|||

[Use it fully without any app](docs/api/console.md)

+++
===

### Install

+++ With Bundler

If you use Bundler, add the gem in the Gemfile, optionally avoiding the next major version with breaking changes (
see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):

||| Gemfile

```ruby   
gem 'pagy', '~> 7.0' # omit patch digit
```

|||

+++ Without Bundler

If you don't use Bundler, install and require the Pagy gem:

||| Terminal

```bash
gem install pagy
```

|||

||| Ruby file

```ruby
require 'pagy'
```

|||
+++

### Configure

+++ With Rails
Download the configuration file linked below and save it into the `config/initializers` dir

[!file](/lib/config/pagy.rb)

+++ Without Rails
Download the configuration file linked below and require it when your app starts

[!file](/lib/config/pagy.rb)
+++

!!! Pagy doesn't load unnecessary code in your app!
Uncomment/edit the `pagy.rb` file in order to **explicitly require the extras** you need and eventually customize the
static `Pagy::DEFAULT` variables in the same file.

You can further customize the variables per instance, by explicitly passing any variable to the `Pagy*.new` constructor or to
any `pagy*` backend/controller method.
!!!

### Backend Setup

+++ Standard
=== Include the backend

||| ApplicationController/AnyController

```ruby
include Pagy::Backend
```

|||

=== Use the `pagy` method
||| Controller action

```ruby
@pagy, @records = pagy(Product.some_scope)
```
|||


===

+++ Search
For search backends
see: [elasticsearch_rails](/docs/extras/elasticsearch_rails), [meilisearch](/docs/extras/meilisearch), [searchkick](/docs/extras/searchkick), [ransack](/docs/how-to/#paginate-ransack-results).

+++ Special
You may also use
the [calendar](/docs/extras/calendar), [countless](/docs/extras/countless), [geared](/docs/extras/gearbox), [incremental, auto-incremental, infinite](/docs/extras/support)
pagination

+++

### Render the pagination

+++ Server Side
!!! success
Your pagination is rendered on the server
!!!

Include the frontend

||| ApplicationHelper/AnyHelper

```ruby
include Pagy::Frontend
```

|||

Use a fast helper
||| Helper

```erb
<%# Note the double equals sign "==" which marks the output as trusted and html safe: %>
<%== pagy_nav(@pagy) %>
```

|||

!!! CSS Frameworks/Styles Available
The pagy helpers are available for different frameworks and different styles (static, responsive, compact, etc.) [bootstrap](docs/extras/bootstrap.md), [bulma](docs/extras/bulma.md), [foundation](docs/extras/foundation.md), [materialize](docs/extras/materialize.md), [semantic](docs/extras/semantic.md), [uikit](docs/extras/uikit.md)
!!!

+++ Javascript Framework

!!! success
Your pagination is rendered by Vue.js, react.js, ...
!!!

Require the [metadata extra](docs/extras/metadata.md)

||| pagy.rb (initializer)

```ruby
require 'pagy/extras/metadata'
```

|||

Add the metadata to your JSON response
||| Controller action

```ruby
render json: { data: @records, pagy: pagy_metadata(@pagy, ...) }
```

|||

+++ API Service

!!! success
Your API is consumed by some client
!!!

Require the [headers extra](docs/extras/headers.md)

||| pagy.rb (initializer)

```ruby
require 'pagy/extras/headers'
```

|||

Add the pagination headers to your responses
||| Controller

 ```ruby
 after_action { pagy_headers_merge(@pagy) if @pagy }
 ```

|||

Render your JSON response as usual
||| Controller action

 ```ruby
 render json: { data: @records }
 ```

|||
+++