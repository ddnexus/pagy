# Pagy on Docker

This dir contains a few files to setup a development environment without installing anything on your system.

You can use it to develop changes, run tests and check a live preview of the documentation.

### Overview

The pagy docker environment has been designed to be useful for developing:

- It provides the infrastructure required (right version of ruby, jekyll server, env variables, tests, etc.) without the hassle to install and maintain anything in your system
- The local `pagy` dir is mounted at the container dir `/opt/project` so you can edit the files in your local pagy dir or in the container: they are the same files.
- The gems are installed in the container `BUNDLE_PATH=/usr/local/bundle` and that dir is `chown`ed to your user, and mounted as the docker volume `pagy_bundle`. You can use the `bundle` command and it will be persisted in the volume, no need to rebuild the image nor pollute your own system.
- Your container user `HOME` is preserved in the `pagy_user_home` volume, so you can even get back to the shell history in future sessions.

## Prerequisites

- recent `docker`
- recent `docker-compose`
- basic knowledge of docker/docker-compose

## Start it

Set in your IDE or system a few variables about your user:

- the `GROUP` name (get it with `id -gn` in the terminal)
- the `UID` (get it with `id -u` in the terminal)
- the `GID` (get it with `id -g` in the terminal)

You can also specify a few other variables used in the `docker-compose.yml` file.

If you already set the variables:

```sh
cd pagy3-on-docker
docker-compose build pagy pagy-jekyll
```

or just set them with the command. For example:

```sh
cd pagy3-on-docker
GROUP=$(id -gn) UID=$(id -u) GID=$(id -g) docker-compose build pagy pagy-jekyll
```

You need to run this only once, when you build the images. After that you just run th containers (see below).

## Use it

Run the containers from the pagy3-on-docker dir:

```sh
docker-compose up
```

Open a terminal in the pagy container and run the usual `bundle install` to install the gems into the `pagy_bundle` volume.

Then you can run `irb -I lib -r pagy` from the container in order to have `pagy` loaded and ready to try.

Run all the tests by simply running `rake` without arguments.

Notice: The rake taks is needed because certain tests must run in an isolated ruby process. For example, certain extras override the core pagy methods and we need to test how pagy works with or without the extra, or with many extras at the same time. You can get the full list of of all the test tasks (and test files that each task run) with `rake -D test_*`

Check the coverage at `http://0.0.0.0:63342/pagy/coverage`

The `pagy-jekyll` service runs the jekyll server so you can edit the docs files from the local `pagy` dir and have a real-time preview of your changes at `http://localhost:4000`. You don't even need to reload the page in the browser to see the change you do in the `*.md` page file.

If you are serious about developing, you can integrate this environment with some good IDE that provides docker and ruby integration. I currently use it for all the basic pagy development, fully integrated with [RubyMine](https://www.jetbrains.com/ruby/?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy).

## Clean up

When you want to get rid of everything related to the `pagy` development on your system:

- `rm -rf /path/to/pagy`
- `docker rmi pagy pagy-gh-pages` or `docker rmi pagy:3 pagy-gh-pages` if you don't want to remove other versions (e.g. `pagy:4`)
- `docker volume rm pagy3_bundle pagy3_user_home pagy3_docs_site`
- `docker system prune` (not pagy related but good for reclaiming storage space from docker)

## Caveats

- If you use different pagy images for different pagy versions/branches:
  - Remember to checkout the right branch before using it
  - If you get some problem running the tests you might need to `rm -rf coverage`
