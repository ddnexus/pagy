---
title: Basic Concepts
---
# Basic Concepts

## Pagination is a simple task

Basically, a pagination gem needs to calculate a series of 10-20 sequential integers (the page numbers) and loop through that series to produce one link per integer. That's just a long string with a few numbers in it, and it's a very simple task... unless someone builds a whole complex world of thousands of objects around a simple series of integers :).

## Pagy keeps it simple

Pagy keeps pagination as straightforward as it could be: there are no "declarative DSL" to learn, no "global pollution" to avoid, no need for any special module or adapter. There are no nested modules, classes nor countless methods and many hundreds lines of code... all really difficult to justify for such a simple task.

Including all the features, validations, exceptions, etc., the Pagy core code is just 3 small files of just above 100 lines in total, easy to understand and use. Just take a look at the source: [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb), [pagy/backend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb), [pagy/frontend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb) .

 Its size and simplicity is one of the reasons of its stunning performance.

## Specialized code instead of generic helpers

Pagy is very specialized. It uses its own code to produce its own HTML, URLs, pluralization and interpolation. Unlike other gems it does not use any generic helpers such as rails helpers (`tag`, `link_to`, `url_for`, `I18n.t`, ...).

Those are perfect helpers but only if used _in an application_.  Because _they are generic_ they can get the job done in any situation, but exactly _because they are generic_, they are just the wrong tool to use _in a pagination gem_. Indeed they are inevitably A LOT slower and use A LOT more memory than specialized methods (or no method at all, like in case of HTML string interpolation extensively used by Pagy).

## Stay away from the models

**Paginating is not business logic**: it has nothing to do with the data itself. It has to do with the way you decide to _present_ the data... one page at the time, n items per page... That is indeed _presentation_ logic, so the models are really not the place where to add that logic!

**Every collection knows already how to paginate itself**: that's what OFFSET and LIMIT in DBs are for! You decide the limit (the items per page) and Pagy (or yourself) can calculate the offset with simple arithmetic: `offset = items * (page - 1)`. That's not rocket science! You don't need to add a bunch of methods to your models just to get the page records!

Ignoring these simple rules has a lot of drawbacks for performance, memory, maintenance, complexity and usability, as you can confirm with the [Gems Comparison page](http://ddnexus.github.io/pagination-comparison).

## No rails engine needed

You don't need a rails engine for a simple task like pagination: you just need a few lines of plain ruby to get it right, fast and light in **any** framework, not just rails.

## Really agnostic pagination

Pagy provides the clean logic of pagination in one micro-class of less than 40 lines of code that creates a micro-object of less than 3k: it works perfectly, knowing **absolutely nothing** about your environment. _(see the [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb))_

You could even use it directly (without using any other Pagy code) in a small partial template that you could write in just 5 minutes and about 15 lines. There you could use the regular helpers provided by your framework and it would still work a few times faster than using other gems, even without using any Pagy template nor any other Pagy method.

## Really easy to customize

If options and configuration are not enough, you have a few specialized [extras](extras.md), and if all that is still not enough, any other special customization is at most _one step far_ from your own code. All the Pagy helpers are contained in 2 plain modules with no nesting. You include them in your code, so you can override any method right where you use it: no tricky gimmickry required.

What could be easier?
