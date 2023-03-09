---
title: Pagy::Console
categories: 
- Module
---

# Pagy::Console

Allows you to test Pagy in an [irb](https://github.com/ruby/irb) with an environment stubbed for you:

<details>

Standard pagination requires a: controller, model, view and request object to work i.e. you need an environment. `Pagy::Console` gives you that environment. 

</details>

</br>

+++ irb
```ruby
require 'pagy/console'
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
+++ rails console

!!!warning Warning

Avoid using `rails console` with `Pagy::Console`.

Use `irb` instead. However, if you need `rails console` please ensure you temporarily "unfreeze" the `Pagy::DEFAULT` hash, in your `pagy.rb` config file, otherwise you'll receive a "can't modify frozen Hash" exception:

```rb
# Pagy::DEFAULT.freeze  ## temporarily comment out this line, don't forget to uncomment when finished!
```
!!!

Now, refer to the instructions in the [irb tab](#irb).

+++

## Pagy::Console module

The pagy console uses the [standalone extra](/docs/extras/standalone.md) and sets the `Pagy::DEFAULT[:url]` variable default to `"http://www.example.com/subdir"` in order to activate the standalone mode.

Include the module in your console window in order to include also the `Pagy::Backend` and `Pagy::Frontend` modules.

==- `pagy_extras(*extras)`

Simple utility method to save some typing in the console. It will require the extras arguments. For example:

```ruby
pagy_extras :array, :bootstrap, :support, :headers, ...
```

You will be able to use any frontend or backend method implemented by pagy and the required extras right away.

===
