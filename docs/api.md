---
title: API
---
# API

[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)

The whole core structure of Pagy is very simple: it is organized around 3 small modules of just ~100 lines of code in total:

| Module           | Description                                                                                                     | Links                                                                                                        |
|:-----------------|:----------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| `Pagy`           | The small class that keeps track of the variables involved in the pagination                                    | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb), [documentation](api/pagy.md)              |
| `Pagy::Backend`  | The optional module that you can include in your controllers in order to automatically create the Pagy instance | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb), [documentation](api/backend.md)   |
| `Pagy::Frontend` | The module to include in your views in order to get a few helpers for the HTML output                           | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb), [documentation](api/frontend.md) |

However, besides these files, you can explicitly require optional [extras](extras.md) that can handle special features, collections or environments.

See also: [Global Configuration](how-to.md#global-configuration)
