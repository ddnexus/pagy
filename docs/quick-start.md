
# Quick Start

=== Try Pagy

If you want to just try Pagy before using it in your own app, you have a couple of alternatives

+++ Standalone Application
  - Ensure to have `rack` installed (or `gem install rack`)
  - [Use the pagy_standalone_app.ru](https://github.com/ddnexus/pagy/blob/master/apps/pagy_standalone_app.ru) (usage notes in the file)
+++ Pagy Console
  - Just `gem install pagy`
  - [Use it fully without any app](api/console.md)
+++
===

## Use Pagy in your app

=== Install Pagy

+++ With Bundler

If you use Bundler, add the gem in the Gemfile, optionally avoiding the next major version with breaking changes (see [RubyGem Specifiers](http://guides.rubygems.org/patterns/#pessimistic-version-constraint)):
    
||| Gemfile
```ruby   
gem 'pagy', '~> 5.10' # omit patch digit
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
===
     
=== Configure Pagy
+++ With Rails

Download the configuration file linked below and save it into the `config/initializers` dir

[!file](../lib/config/pagy.rb)
+++ Without Rails
Download the configuration file linked below and require it when your app starts

[!file](../lib/config/pagy.rb)
+++

!!! Notice
Pagy doesn't load unnecessary code in your app!
                
Uncomment/edit the `pagy.rb` file in order to **explicitly require the extras** you need and eventually customize the static `Pagy::DEFAULT` variables in the same file.

You can further customize the variables per instance, by explicitly passing any variable to the `Pagy*.new` constructor or to any `pagy*` controller method.
!!!
===

=== Include the Backend
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

=== Render the pagination:

+++ Server Side

Include the frontend 
        
||| ApplicationHelper/AnyHelper
```ruby
include Pagy::Frontend
```
|||

Render the navigation links with a fast helper or template

||| Helper
```erb
<%# Note the double equals sign "==" which marks the output as trusted and html safe: %>
<%== pagy_nav(@pagy) %>
```
||| Template
```erb
<%== render partial: 'pagy/nav', locals: {pagy: @pagy} %>
```
|||               
!!! Notice
Helpers and templates are available for different frameworks n different flavors (static, responsive, compact, etc.) [bootstrap](extras/bootstrap.md), [bulma](extras/bulma.md), [foundation](extras/foundation.md), [materialize](extras/materialize.md), [semantic](extras/semantic.md), [uikit](extras/uikit.md) i
!!!

+++ Javascript Framework
   
!!! Recommended when
Your pagination is rendered by Vue.js, react.js, ...
!!!

1. require the [metadata extra](extras/metadata.md) by uncommenting the following line in your [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) file:

    ```ruby
    require 'pagy/extras/metadata'
    ```

2. add the metadata to your JSON response:

   ```ruby
   render json: { data: @records,
                  pagy: pagy_metadata(@pagy, ...) }
   ```
+++ API Service 
         
!!! Recommended when
Your API is consumed by some client and doesn't provide any UI on its own.
!!!

1. require the [headers extra](extras/headers.md) by uncommenting it in your [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) file:

    ```ruby
    require 'pagy/extras/headers'
    ```

2. add the pagination headers to your responses:

    ```ruby
    after_action { pagy_headers_merge(@pagy) if @pagy }
    ```

3. render your JSON response as usual:

    ```ruby
    render json: { data: @records }
    ```
+++
===
