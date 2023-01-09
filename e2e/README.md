
# E2E Test Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the client side. They are tested with a sinatra/rackup/puma ruby app and [Cypress](https://www.cypress.io).

If you you need to run the E2E tests, here are two different ways to run them.

## 1. Github Actions

Just create a PR and all the ruby and e2e tests will run on GitHub. Usually this option is fine for simple PRs that pass the ruby tests.

**Notice**: This option is not enabled by default in Github for new contributors, however after you create a PR it will get enabled ASAP.

## 2. Run E2E Tests On Your System

[Install Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress) and then:

```shell
<local-pagy-dir>/e2e $ npm run test
# or run the test interactively
<local-pagy-dir>/e2e $ npm run test-open
```
