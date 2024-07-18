---
title: Pagy::Console
categories:
  - Module
---

# Pagy::Console

Allows you to test Pagy in an [irb](https://github.com/ruby/irb) with an environment stubbed for you:

<details>

Standard pagination requires a: controller, model, view and request object to work i.e. you need an environment. `Pagy::Console`
gives you that environment.

</details>

</br>

+++ irb

```ruby
require 'pagy/console'
include Pagy::Console
pagy_extras :array, :metadata, ...

### then you can use it like inside an app
pagy, items = pagy_array((1..1000).to_a, page: 3)
pagy_nav(pagy)
=> [#<Pagy:0x00007fdff0234880 @count=1000, @from=41, @in=20, @limit=20, @last=50, @next=4, @offset=40, @outset=0, @page=3, @prev=2, @to=60, @vars={:page=>3, :limit=>20, :outset=>0, :size=>7, :cycle=>false, :count_args=>[:all], :page_param=>:page, :url=>"http://www.example.com/subdir", :count=>1000}>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]
=> "<nav class=\"pagy nav\" aria-label=\"Pages\"><a href=\"http://www.example.com/subdir?page=2\" aria-label=\"Previous\">&lt;</a><a href=\"http://www.example.com/subdir?page=1\">1</a><a href=\"http://www.example.com/subdir?page=2\">2</a><a role=\"link\" aria-disabled=\"true\" aria-current=\"page\" class=\"current\">3</a><a href=\"http://www.example.com/subdir?page=4\">4</a><a href=\"http://www.example.com/subdir?page=5\">5</a><a href=\"http://www.example.com/subdir?page=6\">6</a><a href=\"http://www.example.com/subdir?page=7\">7</a><a href=\"http://www.example.com/subdir?page=4\" aria-label=\"Next\">&gt;</a></nav>"

pagy_metadata(pagy)pagy_metadata(pagy)
=>
{ :scaffold_url => "http://www.example.com/subdir?page=__pagy_page__",
  :first_url    => "http://www.example.com/subdir?page=1",
  :prev_url     => "http://www.example.com/subdir?page=2",
  :page_url     => "http://www.example.com/subdir?page=3",
  :next_url     => "http://www.example.com/subdir?page=4",
  :last_url     => "http://www.example.com/subdir?page=50",
  :count        => 1000,
  :page         => 3,
  :limit        => 20,
  :vars         => { :page       => 3,
                     :limit      => 20,
                     :outset     => 0,
                     :size       => 7,
                     :cycle      => false,
                     :count_args => [:all],
                     :page_param => :page,
                     :url        => "http://www.example.com/subdir",
                     :metadata   => [:scaffold_url,
                                     :first_url,
                                     :prev_url,
                                     :page_url,
                                     :next_url,
                                     :last_url,
                                     :count,
                                     :page,
                                     :limit,
                                     :vars,
                                     :pages,
                                     :last,
                                     :in,
                                     :from,
                                     :to,
                                     :prev,
                                     :next,
                                     :series],
                     :count      => 1000 },
  :pages        => 50,
  :last         => 50,
  :in           => 20,
  :from         => 41,
  :to           => 60,
  :prev         => 2,
  :next         => 4,
  :series       => [1, 2, "3", 4, 5, 6, 7] }
```

+++ rails console

!!!warning Warning

Avoid using `rails console` with `Pagy::Console`.

Use `irb` instead. However, if you need `rails console` please ensure you temporarily "unfreeze" the `Pagy::DEFAULT` hash, in
your `pagy.rb` config file, otherwise you'll receive a "can't modify frozen Hash" exception:

```rb
# Pagy::DEFAULT.freeze  ## temporarily comment out this line, don't forget to uncomment when finished!
```

!!!

Now, refer to the instructions in the [irb tab](#irb).

+++

## Pagy::Console module

The pagy console uses the [standalone extra](/docs/extras/standalone.md) and sets the `Pagy::DEFAULT[:url]` variable default
to `"http://www.example.com/subdir"` in order to activate the standalone mode.

Include the module in your console window in order to include also the `Pagy::Backend` and `Pagy::Frontend` modules.

==- `pagy_extras(*extras)`

Simple utility method to save some typing in the console. It will require the extras arguments. For example:

```ruby
pagy_extras :array, :bootstrap, :support, :headers, ...
```

You will be able to use any frontend or backend method implemented by pagy and the required extras right away.

===
