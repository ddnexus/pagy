---
title: Tailwind
categories:
  - Frontend
  - Extra
image: null
---

# Tailwind Style

<img src="/pagy/docs/assets/images/tailwind.png" width="300" title="Tailwind Style">

Tailwind allows to apply styles to any DOM element, so you don't actually need any special extra to produce a different output. You
can use the standard unstyled pagy helpers: i.e. the default `pagy_nav` and the `pagy_nav_js`and `pagy_nav_combo_js` provided by
the [navs](navs.md) extra and `@apply` the styles to their classes.

You may also want to use the [items extra](items.md) to get the `pagy_items_selector_js` helper. 

## Base Style

!!!success
Adapt the base style to anything you need by just editing the classes in the `@apply` lines, usually leaving the rest untouched
!!!

!!!
You can quickly interact and customize it by running the [pagy_tailwind_app.ru](https://github.com/ddnexus/pagy/blob/master/apps/pagy_tailwind_app.ru) single-file self-contaied app
!!!

+++ All navs

||| SCSS

```scss
.pagination {
  @apply flex space-x-1 font-semibold text-sm text-gray-500;
  .page {
    a {
      @apply block rounded-lg px-3 py-1 bg-gray-200;
      &:hover {
        @apply bg-gray-300;
      }
    }
    &.active a {
      @apply text-white bg-gray-400 cursor-default;
    }
    &.disabled a {
      @apply text-gray-300 bg-gray-100 cursor-default;
    }
  }
  .pagy-combo-input {
    @apply block bg-gray-200 rounded-lg px-3;
    input {
      @apply bg-gray-100 border-none rounded-md mt-0.5;
    }
  }
}
```

|||

+++ Items Selector
     
||| SCSS

```scss
.pagy-items-selector-js {
  @apply inline-block font-semibold text-sm text-gray-500 bg-gray-200 rounded-lg px-3;
  input {
    @apply bg-gray-100 border-none rounded-md my-0.5;
  }
}
```

|||
+++
