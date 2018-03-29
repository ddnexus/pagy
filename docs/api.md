# API

The whole code structure of pagy is very simple: it is organized around 3 small modules of just ~120 lines of code in total:

| Module | Description | Links |
| ---:   | :---        | :---  |
| `Pagy` | The small class (~40 LOC) that keeps track of the variables involved in the pagination | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy.rb), [documentation](/pagy/api/pagy) |
| `Pagy::Backend` | The optional module that you can include in your controllers in order to automatically create the Pagy instance | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb), [documentation](/pagy/api/backend) |
| `Pagy::Frontend` | The module to include in your views in order to get a few helpers for the HTML output | [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/frontend.rb), [documentation](/pagy/api/frontend) |
