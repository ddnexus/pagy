---
title: pagy 🐸 Initializer
icon: gear
order: 100
---

You can use the initializer to configure pagy for your app.

### Inheritable Options

Pagy has an inheritable options system that allows you to set and override options at three different levels:

- `Pagy.options`
  - Global options for all paginators and methods
  - Set it in the initializer
- `pagy` paginator
  - Pass the options to the pagy method: they will be usable by all the `@pagy` instance methods
- `@pagy` instance method
  - Options for the specific component/helper method

!!!warning 

- Pass the options as far down the chain as possible, for explicit readability and maintenance.
- Pass them up the chain, when you truly need them broadly applied.
!!!

### Initializer file

Download or copy the small file below and ensure it loads _(e.g., save it into the Rails `config/initializers` directory or require it)_. Read its comments for details.

[!file pagy.rb](../gem/config/pagy.rb)

:::code source="../gem/config/pagy.rb" title="pagy.rb":::
