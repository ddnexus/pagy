# E2E Test Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the client side. They are
tested with the [Pagy Playground](https://ddnexus.github.io/pagy/playground/) apps and [Cypress](https://www.cypress.io).

Notice: the `e2e` dir containing the cypress tests is also a minimalistic workspace. That is a solution needed to workaround [this cypress issue](https://github.com/cypress-io/cypress/issues/22273) and keep everything cypress-related in a single dir inside the project (instead of files and dirs mixed with the main project). 
    
## Testing

You have two different ways to run the tests:

### 1. Github Actions

Just create a PR and all the ruby and e2e tests will run on GitHub. Usually this option is fine for simple PRs that pass the ruby
tests.

**Notice**: This option is not enabled by default in Github for new contributors, however after you create a PR it will get
enabled ASAP.

### 2. Run E2E Tests On Your System

The test environment uses [bun](https://bun.sh) ([but cypress still needs node ATM](https://github.com/cypress-io/cypress/issues/28962) )
- Install [bun](https://bun.sh/docs/installation)
- Install modules: `bun install`
- Optional for updating packages: 
  - Install: `npm-check`: `bun install -g npm-check`
  - Interactive usage: `npm-check -u`

#### Run the test for all the apps

You can run all the cypress tests in parallel with:

```shell
./e2e/cy/test
```

Notice:

- The output of the parallel processes get mixed in the same log stream, however the test summaries are prefixed with the app name.
- The script will return a non-zero status if any of the test fail, and will print a brief feedback.

#### Run the test for a single app

You can limit the cypress test to a specific APP:

```shell
./e2e/cy/test repro
```

#### Run the test interactively

You can also run the cypress test interactively (only one APP/file at the time) opening cypress UI:

```shell
./e2e/cy/open demo
```

Notice: You can only run the spec file for the app that is running (e.g. `demo.cy.ts` in the example above)
 
## Reconciling test snapshots

The pagy e2e testing is mostly based on snapshots, so if you changed the pagy output you may need just to reconcile it with the 
snapshot values by running this command (that runs the tests and stores their new value):

```shell
 ./e2e/cy/reconcile
```
---

See also [Ruby Test Environment](https://github.com/ddnexus/pagy/tree/master/test)
