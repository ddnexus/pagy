---
order: 4
icon: rocket-24
---

# Quick Start

If you want to just try Pagy before using it in your own app, you have a couple of alternatives...

+++ Browser

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
gem install pagy
pagy demo
```
...and point your browser to http://0.0.0.0:8000
!!!

+++ Console

Interact with every method, helper and extra in a IRB console without any setup:

```sh Terminal
gem install pagy
```

...and [use it without any app](docs/api/console.md)

+++

### 1. Install

+++ With Bundler

If you use Bundler, add the gem in the Gemfile, optionally avoiding the next major version with breaking changes (
see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):

```ruby Gemfile
gem 'pagy', '~> 9.1' # omit patch digit
```

+++ Without Bundler

If you don't use Bundler, install and require the Pagy gem:

```shell Terminal
gem install pagy
```

```ruby Ruby file
require 'pagy'
```
+++

### 2. Configure

+++ With Rails
Download the configuration file linked below and save it into the `config/initializers` dir

[!file](/gem/config/pagy.rb)

+++ Without Rails
Download the configuration file linked below and require it when your app starts

[!file](/gem/config/pagy.rb)
+++

!!! Pagy doesn't load unnecessary code in your app!
Uncomment/edit the `pagy.rb` file in order to **explicitly require the extras** you need and eventually customize the
static `Pagy::DEFAULT` variables in the same file.

You can further customize the variables per instance, by explicitly passing any variable to the `Pagy*.new` constructor or to
any `pagy*` backend/controller method.
!!!

### 3. Backend Setup

+++ Standard

#### Include the backend

```ruby ApplicationController/AnyController
include Pagy::Backend
```

#### Use the `pagy` method

```ruby Controller action
@pagy, @records = pagy(Product.some_scope)
```

+++ Search
For search backends
see: [elasticsearch_rails](/docs/extras/elasticsearch_rails), [meilisearch](/docs/extras/meilisearch), [searchkick](/docs/extras/searchkick), [ransack](/docs/how-to/#paginate-ransack-results).

+++ Special
You may also use
the [calendar](/docs/extras/calendar), [countless](/docs/extras/countless), [geared](/docs/extras/gearbox), [incremental, 
auto-incremental, infinite](/docs/extras/pagy) and [keyset](/docs/api/keyset)
pagination

+++

### 4. Render the pagination

+++ Server Side
!!! success
Your pagination is rendered on the server
!!!

#### Include the frontend

```ruby ApplicationHelper/AnyHelper
include Pagy::Frontend
```

#### Use a fast helper

```erb View
<%# Note the double equals sign "==" which marks the output as trusted and html safe: %>
<%== pagy_nav(@pagy) %>
```

#### Pick a stylesheet or a CSS framework

- For native pagy helpers (used also with tailwind), you can integrate the [Pagy Stylesheets](/docs/api/stylesheets.md)
- For different CSS frameworks and different helpers (static, responsive, compact, etc.), you can look at the [bootstrap](docs/extras/bootstrap.md), [bulma](docs/extras/bulma.md) extras

+++ Javascript Framework

!!! success
Your pagination is rendered by Vue.js, react.js, ...
!!!

#### Require the [metadata extra](docs/extras/metadata.md)

```ruby pagy.rb (initializer)
require 'pagy/extras/metadata'
```

#### Add the metadata to your JSON response

```ruby Controller action
render json: { data: @records, pagy: pagy_metadata(@pagy, ...) }
```

+++ API Service

!!! success
Your API is consumed by some client
!!!
           
#### Consider using the Keyset pagination

Orders of magnitude faster on big data... see [Pagy::Keyset](/docs/api/keyset)

#### Require the [headers extra](docs/extras/headers.md)

```ruby pagy.rb (initializer)
require 'pagy/extras/headers'
```

#### Add the pagination headers to your responses

 ```ruby Controller
 after_action { pagy_headers_merge(@pagy) if @pagy }
 ```

#### Render your JSON response as usual

 ```ruby Controller action
 render json: { data: @records }
 ```
+++
