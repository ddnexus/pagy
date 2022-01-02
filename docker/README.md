# Pagy Docker Environment

This dir contains the docker files to setup a complete development environment without installing anything on your system.

You can use it to develop changes, run ruby and E2E tests, and check the live preview of the documentation.

## Prerequisites

- recent `docker`
- recent `docker-compose`
- basic knowledge of `docker`/`docker-compose`

## Caveats

It works well on Linux. Other platforms are not tested but should work as well.

## Optional

- `Visual Studio Code` or `RubyMine` (the repo contains a complete and ready to use setup that will make your life super easy)

# Pagy Development Environment

The pagy docker environment has been designed to be a complete setup for development. It provides the infrastructure required (right version of ruby, development gems, jekyll server, env variables, tests, cypress, etc.) without the hassle to install and maintain anything in your system.

Here are a few highlights:
- The `pagy-dev` container is run as your user (same name, UID and GID) and the local `pagy` dir is mounted at the container dir `/pagy` so you can edit the files in your local pagy dir or in the container: they are the same files edited by the same user.
- The gems are installed and persisted in the container `BUNDLE_PATH=/usr/local/bundle` and that dir is `chown`ed to your user, and mounted as the docker volume `pagy_bundle`: no need to rebuild the image no mixup with your own ruby/rubies.
- Your container user `HOME` is persisted in the `pagy_user_home` volume, so you can even get back to the shell history in future sessions.
- The `node_modules` dir is persisted in the `pagy_node_modules` volume: no mixup with your local `node` 
- The `opt/site` is persisted in the `docs_site` volume and updated live at `http://0.0.0.0:4000`, so you can check how the documentation looks while editing it.

## :pushpin: Dir Map

- Exec docker-related commands from your local `<local-pagy-dir>/docker` dir (repo `docker` dir)
- Exec commands from the container `/pagy` dir (repo root dir)

## Build

Run in the local terminal: 

```sh
<local-pagy-dir>/docker $ ./setup-env.sh && DOCKER_BUILDKIT=1 docker-compose build
```

**Notice**: the `setup-env.sh` creates an `.env` file with what is needed to build the docker images with `docker-compose`. You can further customize the `.env` file after it is created.

## If you don't use any specific IDE

**Notice**: see [VSCode](#vscode) or [RubyMine](#rubymine) for specific setups.

In order to complete the setup, you need to issue a couple of commands from the container terminal, so first open a bash session:

```sh
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev bash
```

Then run the following commands in it:

```shell
/pagy $ bundle install
/pagy $ npm ci
```

### Use the services

Start the services:

```sh
<local-pagy-dir>/docker $ docker-compose up 
```

Open a shell in the running `pagy-dev` service (useful to interactively run commands):

```shell
<local-pagy-dir>/docker $ docker-compose exec pagy-dev bash
```

then run from the container shell a few useful commands:

```sh
# IRB with the `pagy` gem loaded and ready to try
/pagy $ irb -I lib -r pagy
# run the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks in one command
/pagy $ rake
# get also the coverage report (check it by opening the `coverage/index.html` in a browser)
/pagy $ HTML_REPORTS=true rake
# get list of tests available (so you can run them individually)
/pagy $ rake -D test_*
# run the e2e tests in the terminal
/pagy $ e2e/cy run 
# open cypress and run the test in its GUI
/pagy $ e2e/cy open 
```

Check the live docs site at `http://localhost:4000`. It reflects in real-time any update you do to the `*.md` page files (no page reload needed).

Stop the services:

```sh
<local-pagy-dir>/docker $ docker-compose down 
```

Or run a service only for the execution of a specific command (it does not require `up` and `down`):

```shell
# run all the ruby tests, including rubocop and coverage tasks
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev rake
# run the e2e tests in the terminal
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev e2e/cy run
# open cypress and run the test in its GUI
<local-pagy-dir>/docker $ docker-compose run --rm pagy-dev e2e/cy open
```

## VSCode

The Pagy repository comes with the VSCode files that setup a complete **Development Environment** on your local installation almost automatically.

1. Read the comments in the `docker/docker-compose.override-example.yml` file and create your own `docker-compose.override.
   yml` before anything else.
2. You need the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension. Installation instructions:
   1. Open VS Code, and hit: `Ctrl+P`
   2. Paste `ext install ms-vscode-remote.remote-containers`
   3. Hit `Enter`
3. Run the `Remote-Containers: Open Folder in Container...` command and pick your local `pagy` repository dir (VSCode will prepare the environment).
4. Run `bundle install` in the container terminal to complete the ruby setup.
5. Run `npm ci` in the container terminal to complete the e2e setup.
6. Open Cypress from the container terminal with `e2e/cy open` go to Settings and choose VSCode as the File Opener.

### Setup Solargraph

- Run in container terminal `bundle exec yard gems`
- VSCode command `Solargraph: Rebuild all gem documentation`
- VSCode command `Solargraph: Download current Ruby documentation`
- VSCode command `Solargraph: Restart Solargraph`

### Ready to use

- Rubocop linting and formatting
- Solargraph intellisense
- One-click-run all the tasks from the `Task Manager` list (find its Icon in the Activity Bar)
- Ready to use generic and pagy-specific debugger launch configurations
- The most useful extensions for developing pagy (take a look in the `Pagy Dev Container: Pagy - Installed` Extension group)
- [Intelligent code completion](https://docs.cypress.io/guides/tooling/IDE-integration#Intelligent-Code-Completion) for Cypress and the custom Pagy commands already setup
- Eslint + VSCode Eslint extension configured for Cypress

### Useful commands

- Instead of typing `irb -I lib -r pagy` you can run IRB from the command palette `Run Terminal Command...`
- Run all the `test`, `rubocop`, `coverage_summary` and `manifest:check` tasks by picking the `test: All` from the `Task Manager`
- Run the `test: All With HTML Reports` from the `Task Manager` to get also a nice HTML coverage report. Check it by opening the `coverage/index.html` in a browser.
- Check the live docs site at `http://localhost:4000`. It updates in real-time any update you do to the `*.md` page files (no page reload needed).

## RubyMine

Pagy offers an unconventional setup for RubyMine that makes it work as it was installed directly in the container (VSCode style). That means that RubyMine will be using a regular local SDK from the container. That usage is simpler and works also where you can find quite a few problems with the traditional remote docker-compose SDK. 

<details>

The pagy docker-compose setup works well for the pagy docker environment, and it works also with VSCode or with different level of integration with other IDEs or CLI. Unfortunately I've got quite a lot of problems to run it as a standard [Docker-compose as a remote interpreter](https://www.jetbrains.com/help/ruby/using-docker-compose-as-a-remote-interpreter.html#set_compose_remote_interpreter), so I abandoned the official remote way and found this way. You can try the official way if you feel adventurous :).

</details>

### Custom setup

In order to make RubyMine work inside the container, you need to take a look at the `docker/docker-compose.override-example.yml`: it contains a working example and the comments that should allow you to customize it for your own system.

<details>

The basic target/stage for using RubyMine from the container is the (`docker-custom-dev`: the default). That enables 98% of capabilities of RubyMine. The only small limitation is that the link won't work from inside RubyMine, since there is no browser installed in the container, nor drivers to share one from your host. However that is the simplest target and the one you should probably pick.

If you are really picky and want to have 100% of browser features, the `Dockerfile` includes also stages for NVIDIA cards. That are bigger builds but you can run also any browser from inside RubyMine, even if the browser is installed on the host. That is what I use for my own development environment (see the `docker/docker-compose.override-example.yml`).

</details>

After you create your own overriding, you should build normally (see [Build](#build)). It will build the `pagy-custom-dev` and everything should work. As soon as you run `docker-compose up` Rubymine should open from the container and you can create a local SDK.

Open the terminal and run this in order to complete the setup:

```shell
/pagy $ bundle install
/pagy $ npm ci
```

**IMPORTANT**: If the Ruby SDK does not find all the gems after installing them, then you may want to check whether the `GEM_PATH` environment variable contains also `/usr/local/bundle/ruby/3.0.0` (`Tools`>`Show Gem Environment`) and add it if needed. To add it you an create a `New local with custom configurator...` SDK, adding the `env GEM_PATH=/usr/local/bundle/ruby/3.0.0:/home/dd/.local/share/gem/ruby/3.0.0:/usr/local/lib/ruby/gems/3.0.0` as `Custom configurator`.

### Run configurations

A few run configurations are provided for interacting with `docker-compose` and the development, giving you the menus to run the more important tasks and tools. RubyMine will pick them up automatically. They work in this setup, but they might have to be adapted if you want to use them in a traditional remote docker-compose SDK.

### Caveats

The coverage has an advanced Simplecov setup and RubyMine may not handle it. If the usual RubyMine coverage tools don't work, you can trigger the coverage by running the task without the RubyMine coverage, or use`rake` or `HTML_REPORTS=true rake` in the terminal.

# Clean up

When you want to get rid of everything related to the `pagy` docker development on your system, here is a list of the commands to find them:

- Volumes: `docker volume ls | grep pagy`
- Images: `docker images | grep -E 'pagy|cypress'` 
- Image dependencies: if you are not using them for other containers, you may also want to check `docker images | grep -E 'ruby|alpine|debian'`
- Containers: `docker ps -a | grep pagy`
- Networks: `docker network ls | grep pagy`
