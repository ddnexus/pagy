# Pagy on Docker

This dir contains a few files to setup a ruby development environment without installing anything on your system.

You can use it to develop changes, run tests and check a live preview of the documentation.

It also includes the docker files to setup a javascript testing environment using `cypress`. See the [E2E Environment](#e2e-environment) below.

## Prerequisites

- recent `docker`
- recent `docker-compose`
- basic knowledge of `docker`/`docker-compose`

# Ruby Dev Environment

The pagy docker environment has been designed to be useful for developing:

- It provides the infrastructure required (right version of ruby, jekyll server, env variables, tests, etc.) without the hassle to install and maintain anything in your system
- The local `pagy` dir is mounted at the container dir `/pagy` so you can edit the files in your local pagy dir or in the container: they are the same files.
- The gems are installed in the container `BUNDLE_PATH=/usr/local/bundle` and that dir is `chown`ed to your user, and mounted as the docker volume `pagy_bundle`. You can use the `bundle` command and it will be persisted in the volume, no need to rebuild the image nor pollute your own system.
- Your container user `HOME` is preserved in the `pagy_user_home` volume, so you can even get back to the shell history in future sessions.

## Build

Run in the terminal:

```sh
cd pagy-on-docker
./setup-env.sh
docker-compose build
```

## If you use VSCode (Ruby)

The Pagy repository comes with the VSCode setup files that should reproduce a complete **Ruby development environment** on your local installation almost automatically.

1. Ensure to have the `Remote Containers` extension or install it. You can install it manually with `Ctrl+P`, paste `ext install ms-vscode-remote.remote-containers` and `Enter`.
2. Run the `Remote-Containers: Open Folder in Container...` command and pick your local `pagy` repository dir (VSCode will prepare the environment).
3. Run `bundle install` in the terminal to complete the ruby setup.

### Setup Solargraph

- Run in terminal `bundle exec yard gems`
- VSCode command `Solargraph: Rebuild all gem documentation`
- VSCode command `Solargraph: Download current Ruby documentation`
- You may need to restart Solargraph or close and reopen the VSCode window

### Ready to use Features

- Rubocop linting
- Solargraph intellisense
- One-click-run rake tasks from the `Task Manager` list (find its Icon in the Activity Bar)
- Ready to use generic and pagy-specific debugger launch configurations
- The most useful extensions for developing pagy (take a look in the `Dev Container: Pagy - Installed` Extension group)

### Useful commands

- Run `irb -I lib -r pagy` in order to have the `pagy` gem loaded and ready to try
- Run all the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks by picking the 'test: All`
- Run the `test: All With HTML Reports` to get a nice coverage report. Check it by opening the `coverage/index.html` in a browser.
- Check the local jekyll docs site at `http://localhost:4000`. It updates in real-time any update you do to the `*.md` page files (no page reload needed).

## If you don't use VSCode

Run the containers from the `pagy-on-docker` dir:

```sh
docker-compose run --rm pagy bash
```

Run `bundle install` in the terminal to complete the ruby setup.

### Useful commands

- Run `irb -I lib -r pagy` in order to have the `pagy` gem loaded and ready to try
- Run all the tests by simply running `rake` without arguments: it will run the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks.
- You can run `rake -T` to get all the tasks or `rake -D test_*` to get only the tests (so you can run them individually)
- You can get a nice coverage report with `HTML_REPORTS=true rake` then check it by opening the `coverage/index.html` in a browser.
- Check the local jekyll docs site at `http://localhost:4000`. It updates in real-time any update you do to the `*.md` page files (no page reload needed).

# E2E Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the server side or on the client side (with improved performance).

They are tested with a sinatra/rackup/puma ruby app and [Cypress](https://www.cypress.io).

Cypress can run in two different testing modes:

- **Headless**: you will see the results in the terminal (enough for regression)
- **Interactive**: you will have a GUI and will see the testing and all the tracking live in a browser (needed for test development)

If you determine that you need to run the E2E tests, here are three different ways to run them:

## 1. Github Actions

Just create a PR and all the tests (including the cypress tests) will run on GitHub. Use this option if you don't need to write any js code or tests interactively and the ruby tests pass.

**Notice**: This option is not enabled in Github by default. Please create the PR and ask for authorization of running the tests.

## 2. Run Cypress Locally On Your System

_**Notice**: This requires `node` and adds quite a few modules to it._

- [Install Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress)
- `rackup -o 0.0.0.0 -p 4567 test/e2e/pagy_app.ru`
- Run your Cypress tests from the pagy root (path depending on your installation):
- **Headless**: `cypress run`
- **Interactive**: `cypress open --project test/e2e`

## 3. Run Cypress in docker

_**Notice**: No installation in your system, no dealing with cypress configuration. Just a few choices related to docker_

### Headless mode (Simple setup)

Check your user id with `id -u`. If it is `1000` you are all setup for building the container.

If it is any other id, you should first edit the `pagy-on-docker/cypress-headless.yml` file and switch (i.e. commenting/uncommenting) the `pagy-cypress.build.dockerimage` entries so they will look like this:

```yml
...
    # switch between the following 2 lines if your user id is 1000 or not
    # dockerfile: pagy-cypress-uid1000.dockerfile
    dockerfile: pagy-cypress.dockerfile
...
```

Now build the image for the `pagy-cypress` service with:

```sh
docker-compose build -f cypress-headless.yml
```

From now on you can run the E2E tests in **headless** mode with the following command from the `pagy-on-docker` dir:

```sh
docker-compose -f docker-compose.yml \
               -f cypress-headless.yml \
               up pagy-cypress
```

That will print a report right on the screen.

It will also create a video for each test file run in the `test/e2e/cypress/videos` (you can disable it adding `"video": false` in the `test/e2e/cypress.json`).

In case of test failures you will also have screenshots images in `test/e2e/cypress/screenshots` showing exactly what was on the page of the browser at the moment of the failure.

### Interactive mode (Advanced setup)

**Notice**: _This setup is very useful if you are going to edit the cypress tests. If you just need to run them, you can avoid this section._

If you want to open and interact the cypress desktop app as it was installed in your local system, and you are lucky enough to run with user id `1000` on an ubuntu system, you can just run it with the command below without customizing anything.

If not, (i.e. different uid or different OS or version) you should first read the comments in the `pagy-on-docker/cypress-interactive.yml` file and customize it a bit according to your OS need.

From now on you can open `cypress` with:

```sh
docker-compose -f docker-compose.yml \
               -f cypress-headless.yml \
               -f cypress-interactive.yml
               run --rm pagy-cypress
               cypress open --project /pagy/test/e2e
```

### If you use VSCode (Cypress)

The Pagy repository comes with the VSCode setup files that should reproduce a complete **Cypress development environment** on your local installation almost automatically.

1. Ensure to have the `Remote Containers` extension or install it. You can install it manually with `Ctrl+P`, paste `ext install ms-vscode-remote.remote-containers` and `Enter`.
2. Run the `Remote-Containers: Open Folder in Container...` command and pick the `test/e2e` inside your local pagy repository dir (VSCode will prepare the environment).
3. Open the Cypress settings and choose VSCode as the File Opener

#### Ready to use Features

- [Intelligent code completion](https://docs.cypress.io/guides/tooling/IDE-integration#Intelligent-Code-Completion) for Cypress and the custom Pagy commands already setup
- Run tests and Open cypress from the command palette `Run Terminal Command...`
