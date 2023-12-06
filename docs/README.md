### Documentation Contributions

Documentation contributions or suggestions are welcome.

1. Download [`retype`](https://retype.com/guides/cli/)
2. `retype start` in the pagy root directory.

And your docs should appear in a browser.

#### Primer on how Pagy's Documentation works

Pagy's documentation is built on [retype](https://retype.com/).

All of [retype's configuration](https://retype.com/configuration/project/) is located in the [`retype.yml` file](https://github.com/ddnexus/pagy/blob/master/retype.yml). 

Pagy uses a [github action](https://github.com/ddnexus/pagy/blob/master/.github/workflows/retype-action.yml) to trigger the build process i.e. the docs need to be "built". Why? Because the docs are written in [markdown format](https://en.wikipedia.org/wiki/Markdown) - however, markdown is not sufficient to deliver html to your browser. Retype does the hard work of converting that markdown into html with styling.

Once built, then [Github pages](https://pages.github.com/) delivers it to you. But we must tell Github to deliver the html that has been created. Where is the html located? The html - i.e. the "built" site - is located in the root directory of the [`docs-site` branch](https://github.com/ddnexus/pagy/tree/docs-site) of the Pagy repository. The admin of the repository can set the branch that is used in the settings section of the repository.

More details on the docs are available on the [retype website](https://retype.com/guides/github-actions/). 

The Pagy repository is using the Open Source version, subject to certain limitations (i.e. total page count). [Pro version](https://retype.com/pro/) opens up other benefits. Credit to: [Retypeapp](https://github.com/retypeapp) and 
[@geoffreymcgill](https://github.com/geoffreymcgill) and possibly others behind the scenes.

