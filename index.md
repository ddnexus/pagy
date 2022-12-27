---
title: Home
icon: home
---
# Basic Concepts

## Pagination is a simple task

A pagination gem needs to calculate 10-20 sequential integers (the page numbers) and loop through them to produce one page link per integer - that's just a long string with a few numbers in it. 

It's a simple task, that ought to be done simply:

## Pagy's Simplicity

* no declarative DSLs, 
* no "global pollution", 
* no need for special modules / adapters, 
* no nested modules, classes nor countless methods
* no hard dependency on Rails - no engine required.

## Advantages - Pagy:

* is barely a lick over 100 lines of code,  and is readily comprehensive - checkout out the core: [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb), [pagy/backend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb), [pagy/frontend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb) 
* paginates using one micro-class that creates a micro-object of less than 3k. 
* knows **nothing** about your environment, 
* is compatible with Rack frameworks like: Rails, Sinatra, Padrino etc, and even pure Ruby without Rack.
* is highly performant.

## Uses specialized code instead of generic helpers

Pagy uses its own code to produce its own HTML, URLs, pluralization and interpolation. Generic helpers are avoided (`tag`, `link_to`, `url_for`, `I18n.t`, ...), because Pagy's specialized methods are significantly more performant. 

## Stays away from models

**Paginating is not business logic**: it has nothing to do with the data itself, but with how the data is *presented:* e.g. ... one page at the time, n items per page ... should such logic really live in your models? Pagy doesn't think so!

**Every collection knows already how to paginate itself**: that's what OFFSET and LIMIT in DBs are for! You decide the limit (the items per page) and Pagy (or yourself) can calculate the offset with simple arithmetic: `offset = items * (page - 1)`. That's not rocket science! 

Ignoring these rules come with drawbacks in: performance, memory, maintenance, complexity and usability - see the [gems Comparison page](http://ddnexus.github.io/pagination-comparison).

## Really easy to customize

Pagy is eminently customizable: consider its options and specialized [extras](/categories/extras), and if that is not enough, special customization is at most _one step far_ from your own code. Simply override a method right where you use it: no tricky gimmickry required.

What could be easier?

