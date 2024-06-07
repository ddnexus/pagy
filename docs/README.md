### How documentation works

The docs are written in [markdown format](https://en.wikipedia.org/wiki/Markdown) and [retype](https://retype.com/) converts it
into styled HTML.

The [retype configuration](https://retype.com/configuration/project/) is located in
the [`retype.yml` file](https://github.com/ddnexus/pagy/blob/master/retype.yml).

The [publish-docs workflow](https://github.com/ddnexus/pagy/blob/master/.github/workflows/publish-docs.yml) builds and
publishes the documentation in the [`docs-site` branch](https://github.com/ddnexus/pagy/tree/docs-site) when its markdown changes
are pushed to the `master` branch.
