# Pagy on Docker

This dir contains the docker files to setup a complete development environment without installing anything on your system.

You can use it to develop changes, run ruby and E2E tests, and check the live preview of the documentation.

## Prerequisites

- recent `docker`
- recent `docker-compose`
- basic knowledge of `docker`/`docker-compose`

## Optional

- `Visual Studio Code` (the repo contains a complete and ready to use VSCode setup that makes your life super easy)

# Ruby Dev Environment

The pagy docker environment has been designed to be a complete setup for developing:

- It provides the infrastructure required (right version of ruby, development gems, jekyll server, env variables, tests, etc.) without the hassle to install and maintain anything in your system
- The local `pagy` dir is mounted at the container dir `/pagy` so you can edit the files in your local pagy dir or in the container: they are the same files.
- The gems are installed  and persisted in the container `BUNDLE_PATH=/usr/local/bundle` and that dir is `chown`ed to your user, and mounted as the docker volume `pagy_bundle` (no need to rebuild the image nor pollute your own system).
- Your container user `HOME` is persisted in the `pagy_user_home` volume, so you can even get back to the shell history in future sessions.

## Build

Run in the local terminal:

```sh
cd pagy-on-docker
./setup-env.sh
docker-compose build
```

:pushpin: __Remember that every docker command must be run from the  `pagy-on-docker` dir.__

**Notice**: the `setup-env.sh` creates an `.env` file with what is needed to build the docker images. You can further customize the `.env` file after it is created.

## If you use VSCode (Ruby)

The Pagy repository comes with the VSCode files that setup a complete **Ruby Development Environment** on your local installation almost automatically.

1. You need the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. Installation instructions:
    1. Open VS Code, and hit: `Ctrl+P`
    2. Paste `ext install ms-vscode-remote.remote-containers`
    3. Hit `Enter`
2. Run the `Remote-Containers: Open Folder in Container...` command and pick your local `pagy` repository dir (VSCode will prepare the environment).
3. Run `bundle install` in the container terminal to complete the ruby setup.

### Setup Solargraph

- Run in container terminal `bundle exec yard gems`
- VSCode command `Solargraph: Rebuild all gem documentation`
- VSCode command `Solargraph: Download current Ruby documentation`
- VSCode command `Solargraph: Restart Solargraph`

### Ready to use

- Rubocop linting and formatting
- Solargraph intellisense
- One-click-run rake tasks from the `Task Manager` list (find its Icon in the Activity Bar)
- Ready to use generic and pagy-specific debugger launch configurations
- The most useful extensions for developing pagy (take a look in the `Dev Container: Pagy - Installed` Extension group)

### Useful commands

- Instead of typing `irb -I lib -r pagy` you can run IRB from the command palette `Run Terminal Command...`
- Run all the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks by picking the `test: All` from the `Task Manager`
- Run the `test: All With HTML Reports` from the `Task Manager` to get also a nice HTML coverage report. Check it by opening the `coverage/index.html` in a browser.
- Check the live docs site at `http://localhost:4000`. It updates in real-time any update you do to the `*.md` page files (no page reload needed).

## If you don't use VSCode

Run the ruby container from the `pagy-on-docker` dir:

```sh
docker-compose run --rm ruby bash
```

Run `bundle install` in the container to complete the ruby setup.

### Start the docs service

```sh
docker-compose docker-compose.docs.yml up
```

Available at `http://0.0.0.0:4000`

### Useful commands from the container

- Run `irb -I lib -r pagy` in order to have the `pagy` gem loaded and ready to try
- Run all the tests by simply running `rake` without arguments: it will run the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks.
- You can run `rake -T` to get all the tasks or `rake -D test_*` to get only the tests (so you can run them individually)
- You can get a nice coverage report with `HTML_REPORTS=true rake` then check it by opening the `coverage/index.html` in a browser.
- Check the live docs site at `http://localhost:4000`. It updates in real-time any update you do to the `*.md` page files (no page reload needed).

# E2E Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the client side. They are tested with a sinatra/rackup/puma ruby app and [Cypress](https://www.cypress.io).

If you you need to run the E2E tests, here are three different ways to run them.

## 1. Github Actions

Just create a PR and all the ruby and e2e tests will run on GitHub. Usually this option is fine for simple PRs that pass the ruby tests.

**Notice**: This option is not enabled in Github for new users by default, however after you create a PR it will get enabled ASAP.

## 2. Run E2E Tests On Your System

This solution is convenient if you already have `node` installed on your system and you need to test your development frequently/locally.

Here are the steps:

- [Install Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress)
- `rackup -o 0.0.0.0 -p 4567 test/e2e/pagy_app.ru`
- Run your Cypress tests from the pagy root (path depending on your installation):
  - **Headless**: `cypress run --project test/e2e`
  - **Interactive**: `cypress open --project test/e2e`

## 3. Run E2E Tests in Docker

This solution is convenient if you don't have `node` installed on your system or you don't want to mess with your local filesystem. Using docker is convenient because you don't have to install and configure anything on your machine.

You have two independent choices(use one or the other):

- **E2E Test**: Simple tool that runs the e2e tests in the local terminal (good enough for regression and super easy to install).
- **E2E Dev**: Complete test-development environment with GUI and all the tools you may need (quite needed for e2e test development but it might need some extra configuration)

### Prerequisite

- The `ruby` docker service is already setup (`bundle install`)

### E2E Test (Simple setup)

If you just need to run the E2E Test for regression, this is the right choice. Notice that if you need the E2E Dev environment you should completely skip this section).

You need only the following two steps:

#### Build

Build the image for the `e2e-test` service. You need this step only once _(and you can ignore the possible warnings doring the build)_:

```sh
docker-compose -f docker-compose.yml \
               -f docker-compose.e2e-dev.yml \
               build e2e-dev
```

#### Run

After building the image, you can run the E2E tests in with the following command:

```sh
docker-compose -f docker-compose.yml \
               -f docker-compose.e2e-test.yml \
               up e2e-test
```

That will print a report right on the screen.

<details>

In case of test failures you will have screenshots images in `test/e2e/cypress/screenshots` showing exactly what was on the page of the browser at the moment of the failure.

If you want to have a video for each test file run in the `test/e2e/cypress/videos`, remove the `"video": false` entry in the `test/e2e/cypress.json`.

</details>

### E2E Dev (Advanced setup)

:warning: __The Cypress GUI from docker will probably not work on Windoze__

This setup is very useful if you are going to edit the e2e tests. If you just need to run them, stick to the [E2E Test (Simple setup)](#e2e-test-simple-setup).

It will allow to open and interact with the cypress desktop app as it was installed in your local system.

### If you use VSCode (E2E)

The Pagy repository comes with the VSCode files that setup a complete **E2E Development Environment** on your local installation almost automatically.

1. You need the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. Installation instructions:
    1. Open VS Code, and hit: `Ctrl+P`
    2. Paste `ext install ms-vscode-remote.remote-containers`
    3. Hit `Enter`
2. Run the `Remote-Containers: Open Folder in Container...` command and pick the `test/e2e` inside your local pagy repository dir (VSCode will prepare the environment).
3. Run `npm install` in the container terminal (notice that it may look like frozen, but it's just downloading cypress).
4. Open Cypress from the container terminal with  `npx cypress open` go to Settings and choose VSCode as the File Opener.

#### Ready to use

- [Intelligent code completion](https://docs.cypress.io/guides/tooling/IDE-integration#Intelligent-Code-Completion) for Cypress and the custom Pagy commands already setup
- Eslint + VSCode Eslint extension configured for Cypress
- Run tests or Open cypress from the command palette `Run Terminal Command...`

### If you don't use VScode (E2e)

#### Build

Build the e2e-dev environment:

```sh
docker-compose -f docker-compose.yml \
               -f docker-compose.e2e-dev.yml \
               build e2e-dev
```

#### Run

Then run a bash session and `npm install` (notice that it may look like frozen for a couple of minutes, but it's just downloading cypress):

```sh
docker-compose -f docker-compose.yml \
               -f docker-compose.e2e-dev.yml \
               run --rm bash

# then in the container:
/pagy/test/e2e $ npm install
# and you can run the test or open cypress and run the test in its GUI
/pagy/test/e2e $ npx cypress run  # headless
/pagy/test/e2e $ npx cypress open # interactive
```

:warning: If Cypress doesn't open, read the comments in the `pagy-on-docker/docker-compose.e2e-test.yml` file and customize it a bit according to your OS need.

# Clean up

When you want to get rid of everything related to the `pagy` docker development on your system, here is a list of the commands to find them:

- Volumes: `docker volume ls | grep pagy`
- Images: `docker images | grep -E 'pagy|cypress'` 
- Image dependencies: if you are not using them for other containers, you may also want to check `docker images | grep -E 'ruby|alpine|debian'`
- Containers: `docker ps -a | grep pagy`
- Networks: `docker network ls | grep pagy`
