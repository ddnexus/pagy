---
title: API
---
# API

The whole core structure of Pagy is very simple: it is organized around 3 small files of just ~100 lines of code in total:

| File                                                                                 | Description                                                                                                                                                |
|:-------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb)                   | It defines the small [Pagy](api/pagy.md) class that keeps track of the variables involved in the pagination                                                |
| [pagy/backend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb)   | It defines the optional [Pagy::Backend](api/backend.md) module that you can include in your controllers in order to automatically create the Pagy instance |
| [pagy/frontend.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb) | It defines the [Pagy::Frontend](api/frontend.md) module to include in your views in order to get a few helpers for the HTML output                         |

Besides the core files you can explicitly require optional [extras](extras.md) that can handle special features, collections or environments.

See also: [Global Configuration](how-to.md#global-configuration)
