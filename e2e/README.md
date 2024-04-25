# E2E Test Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the client side. They are
tested with the [Pagy Playground](https://ddnexus.github.io/pagy/playground/) apps and [Cypress](https://www.cypress.io).

If you you need to run the E2E tests, here are two different ways to run them.

## 1. Github Actions

Just create a PR and all the ruby and e2e tests will run on GitHub. Usually this option is fine for simple PRs that pass the ruby
tests.

**Notice**: This option is not enabled by default in Github for new contributors, however after you create a PR it will get
enabled ASAP.

## 2. Run E2E Tests On Your System

Run `npm -i` or (`pnpm -i` if `pnpm` is installed).

You can sequentially run all the e2e tests with:

```shell
<local-pagy-dir>/e2e $ npm run test-all
```

or limit the e2e test to a specific APP:

```shell
<local-pagy-dir>/e2e $ APP=demo PORT=8080 npm run test
```

You can also run the e2e test interactively (on one APP/file at the time):

```shell
<local-pagy-dir>/e2e $ APP=demo PORT=8080 npm run test-open
```
---

See also [Ruby Test Environment](https://github.com/ddnexus/pagy/tree/master/test)
