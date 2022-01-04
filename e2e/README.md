
# E2E Test Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the client side. They are tested with a sinatra/rackup/puma ruby app and [Cypress](https://www.cypress.io).

If you you need to run the E2E tests, here are three different ways to run them.

## 1. Github Actions

Just create a PR and all the ruby and e2e tests will run on GitHub. Usually this option is fine for simple PRs that pass the ruby tests.

**Notice**: This option is not enabled by default in Github for new contributors, however after you create a PR it will get enabled ASAP.

## 2. Run E2E Tests On Your System

This solution is convenient if you already have `node` installed on your system and you didn't setup the [Docker Development Environment](https://github.com/ddnexus/pagy/tree/master/docker).

You should [Install Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress) and then:

```shell
<local-pagy-dir>/e2e $ npm run test
<local-pagy-dir>/e2e $ npm run test-open
```

## 3. Run E2E Tests in Docker

This solution is bundled with the [Docker Development Environment](https://github.com/ddnexus/pagy/tree/master/docker) setup on your computer.

### Run the E2E tests

If you use VSCode or RubyMine for your development you should have a couple of integrated tasks for running the E2E Tests or opening Cypress.

Here is a more general way to do the same.

#### Run the Cypress tests

If you want to run the E2E Tests with Cypress right in your terminal:

```shell
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev npm -w e2e run test
```

That will print a report right on the screen and exit fro docker.

<details>

In case of cypress test failures you will have screenshots images in `e2e/cypress/screenshots` showing exactly what was 
on the page of the browser at the moment of the failure.

If you want to have a video for each test file run in the `e2e/cypress/videos`, remove the `"video": false` entry in the 
`e2e/cypress.json`.

</details>

### Open the Cypress UI

If you want to open the Cypress and running the tests through its UI just pass `test-open` instead of `test` as the last argument.

```shell
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev npm -w e2e run test-open
```

:warning: If Cypress doesn't open, read the comments in the `docker/docker-compose.override-example.yml` file so you can customize the environment according to your OS need.

Please, check the [Docker Development Environment](https://github.com/ddnexus/pagy/tree/master/docker#if-you-use-vscode) for more details.
