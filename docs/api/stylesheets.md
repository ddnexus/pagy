---
title: Stylesheets
image: null
---

# Stylesheets

<img src="/pagy/docs/assets/images/pagy-style.png" width="300" title="Pagy Style">

For all its own interactive helpers the pagy gem includes a few stylesheets files that you can download, link or copy.

!!!success
You can adapt the stylesheets to anything you need by just editing content inside the curly brackets, usually leaving the rest
untouched.
!!!

+++ pagy.scss

[!file](/lib/stylesheets/pagy.scss)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.scss')
```

:::code source="/lib/stylesheets/pagy.scss" :::

+++ pagy.css

[!file](/lib/stylesheets/pagy.css)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.css')
```

:::code source="/lib/stylesheets/pagy.css" :::

+++ pagy.tailwind.scss

[!file](/lib/stylesheets/pagy.tailwind.scss)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.tailwind.scss')
```

:::code source="/lib/stylesheets/pagy.tailwind.scss" :::

+++

!!!
You can also quickly interact with all the pagy styles (including `pagy` and `tailwind`) by running the single-file self-contaied
app [!file](/apps/pagy_styles.ru)
!!!
