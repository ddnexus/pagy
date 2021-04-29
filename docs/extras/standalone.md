---
title: Standalone
---
# Standalone Extra

This extra allows you to use pagy completely standalone, i.e. without any request object, nor Rack environment/gem, nor any defined `params` method, even in the irb/rails console witout an app.

You may need it in order to paginate a collection outside of a regular rack request or controller, like in an unconventional API module, or in the irb/rails console or for testing/playing with backend and frontend methods.

You trigger the standalone mode by setting an `:url` variable, which will be used directly and verbatim, instead of extracting it from the `request` `Rack::Request` object. You can also pass other params by using the `:params` variable as usual. That will be used to produce the final URLs in the usual way.

This extra will also create a dummy `params` method (if not already defined) in the module where you will include the `Pagy::Backend` (usually a controller).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/standalone'

# optional: set a default url
Pagy::Vars[:url] = 'http://www.example.com/subdir'

# pass a :url variable to work in standalone mode (no need of any request object nor Rack env)
@pagy, @records = pagy(Product.all, url: 'http://www.example.com/subdir', params: {...})
```

In a console, even without any app nor initializer:

```ruby
require 'pagy'
require 'pagy/extras/standalone'
include Pagy::Console
pagy_extras :array, :metadata, ...

### then you can use it like inside an app 
pagy, items = pagy_array((1..1000).to_a, page: 3)
pagy_navs(pagy)
=> "<nav class=\"pagy-nav pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"http://www.example.com/subdir?page=2&items=20\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=1&items=20\"   >1</a></span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=2&items=20\"   rel=\"prev\" >2</a></span> <span class=\"page active\">3</span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=4&items=20\"   rel=\"next\" >4</a></span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=5&items=20\"   >5</a></span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=6&items=20\"   >6</a></span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=7&items=20\"   >7</a></span> <span class=\"page gap\">&hellip;</span> <span class=\"page\"><a href=\"http://www.example.com/subdir?page=50&items=20\"   >50</a></span> <span class=\"page next\"><a href=\"http://www.example.com/subdir?page=4&items=20\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav>"
 
pagy_metadata(pagy)
=> 
{:scaffold_url=>"http://www.example.com/subdir?page=__pagy_page__",
 :first_url=>"http://www.example.com/subdir?page=1",
 :prev_url=>"http://www.example.com/subdir?page=2",
 :page_url=>"http://www.example.com/subdir?page=3",
 :next_url=>"http://www.example.com/subdir?page=4",
 :last_url=>"http://www.example.com/subdir?page=50",
 :count=>1000,
 :page=>3,
 :items=>20,
 :vars=>
  {:page=>3,
   :items=>20,
   :outset=>0,
   :size=>[1, 4, 4, 1],
...
```

## Files

- [standalone.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/standalone.rb)

## Variables

| Variable | Description                              | Default |
|:---------|:-----------------------------------------|:--------|
| `:url`   | url string (can be absolute or relative) | `nil`   |

You can use the `:params` variable to add params to the final URLs.

## Methods

### Overridden pagy_url_for

The `standalone` extra overrides the `pagy_url_for` method used internally. If it finds a set `:url` variable it assumes there is no `request` object, so it uses the `:url` var verbatim to produce the final URL, only adding the query string, composed by merging the `:page` param to the `:params` variable. If there is no `:url` variable set it works like usual, i.e. it uses the rake `request` object to extract the base_url, path from the request, merging the params returned from the `params` controller method, the `:params` variable and the `:page` param to it.

### Dummy params method

This extra creates a dummy `params` method (if not already defined) in the module where you will include the `Pagy::Backend` (usually a controller). The method is called by pagy to retrive backend variables coming from the request, and expects a hash, so the dummy param method returns an empty hash avoiding an error.

## Pagy::Console module

Include it in your console window to include `Pagy::Backend`, `Pagy::Frontend` and set a dummy default `:url` variable.

### pagy_extras(*extras)

Simple utility method to save some typing in the console. It will require the extras arguments:

```ruby
pagy_extra :array, :bootstrap, :support, :headers, ...
```
