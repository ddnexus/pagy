# Pagy Apps

## Repro app

For easily reproduce issues, please use the `pagy` command (available after the installation of the pagy gem).

Here are the simple steps:

### 1. Create a new `repro.ru` app

```sh
pagy create repro
```

You should find the `./repro.ru` new app file in the current dir. Feel ree to rename or move it as you like.

### 2. Develop the app

This command run, log and auto-restart on changes:

```sh
pagy develop path/to/your/renamed-repro.ru
```

Point a browser to `http://0.0.0.0:8000`

### Edit it

Edit the simple app so to reproduce you issue. It will get automatically restarted at each change, 
so you will be able to refresh the browser to see your changes

## Demo app

You can have an interactive showcase of all the helpers and styles by simply running the following command:

```sh
pagy run demo
```

Point a browser to `http://0.0.0.0:8000`

You can also use this app to reproduce a specific issue with a CSS framework or extra. Please, follow the [same steps above](#1-create-a-new-reproru-app) just switching `repro` with `demo`.
