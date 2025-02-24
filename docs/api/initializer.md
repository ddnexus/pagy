---
title: pagy • Initializer
icon: gear
order: 100
---

You can use the initializer to configure pagy for your app.

### Inheritable Options

Pagy has an inheritable options system that allow you to set/override options at 3 different levels:

- `Pagy.options`
  - Global options for all paginators and methods
  - Set it in the initializer
- `pagy` paginator
  - Pass the options to the pagy method: they will be usable by all the `@pagy` instance methods
- `@pagy` instance methods
  - Options for the specific method

!!!warning 

Prefer to pass the options as down the chain as possible, for explicit readability and easier maintenance.
!!!

### Initiaizer file

Download/copy the small file below and ensure it loads _(e.g. save it into the Rails' `config/initializers` dir, or require it)_. Read its comments for detsils.

[!file pagy.rb](../gem/config/pagy.rb)

:::code source="../gem/config/pagy.rb" :::
