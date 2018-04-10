---
title: Pagy Extras
---

# Pagy Extras
`pagy-extras` is a gem that provides the following optional extensions/extras:

| Extra        | Description                                                                                                                                                                   | Links                                                                                                                                                                                                                                          |
|:-------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `bootstrap`  | Nav helper for Bootstrap.                                                                                                                                                     |                        [bootstrap.rb](https://github.com/ddnexus/pagy-extras/blob/master/lib/pagy-extras/bootstrap.rb),                        [documentation](pagy-extras/bootstrap.md)                                                                                                              |
| `responsive` | With this extra the number of page links will adapt in real-time to the available window or container width.                                                                  |                        [responsive.rb](https://github.com/ddnexus/pagy-extras/blob/master/lib/pagy-extras/responsive.rb),                        [pagy-responsive.js](https://github.com/ddnexus/pagy-extras/blob/master/lib/javascripts/pagy-responsive.js),                        [documentation](pagy-extras/responsive.md) |
| `compact`    | This extra is an alternative pagination UI that joins the pagination feature with the navigation info in one compact element. It is especially useful for small size screens. |                        [compact.rb](https://github.com/ddnexus/pagy-extras/blob/master/lib/pagy-extras/compact.rb),                        [pagy-compact.js](https://github.com/ddnexus/pagy-extras/blob/master/lib/javascripts/pagy-compact.js),                        [documentation](pagy-extras/compact.md)                |

## Synopsys

Install and require the pagy-extras gem:
```bash
gem install pagy-extras
```
```ruby
require 'pagy-extras'
```
or if you use the Bundler, add the gem in the Gemfile:
```ruby
gem 'pagy-extras'
```

## Description

This gem doesn't define any new module or class: it just re-opens the `Pagy` class and modules, adding the extra methods as it was part of the `pagy` gem. This neatly separates the core code from the optional extras, still keeping its usage as simple as it was part of the core gem.

## Methods

All the methods are documented in the respective extras, with the exception of the following:

### Pagy.extras_root

This method returns the `pathname` of the `pagy-extras/lib` root dir. It is useful to get the absolute path of template files installed with the gem.
