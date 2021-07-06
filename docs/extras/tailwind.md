---
title: Tailwind
---
# Tailwind Extra Styles

Tailwind allows to apply styles to any DOM element, so you don't actually need a special extra to produce a different output. You can use the standard unstyled pagy helpers: i.e. the default `pagy_nav` and the `pagy_nav_js`and `pagy_nav_combo_js` provided by the [navs](navs.md) extra, and apply the styles to their classes.

## Synopsis

See the [navs](navs.md) extra if you use `pagy_nav_js` or `pagy_combo_nav_js`.

Copy and customize the following basic rules to apply the styles to the pagy CSS classes:

```scss
@import "~tailwindcss/base";


.pagy-nav,
.pagy-nav-js {
  @apply flex space-x-2;
}

.pagy-nav .page a,
.pagy-nav .page.active,
.pagy-nav .page.prev.disabled,
.pagy-nav .page.next.disabled,
.pagy-nav-js .page a,
.pagy-nav-js .page.active,
.pagy-nav-js .page.prev.disabled,
.pagy-nav-js .page.next.disabled {
  @apply block rounded-lg px-3 py-1 text-sm text-gray-500 font-semibold bg-gray-200 shadow-md;
  &:hover{
    @apply bg-gray-300;
  }
  &:active{
    @apply bg-gray-400 text-white;
  }
}

.pagy-nav .page.prev.disabled,
.pagy-nav .page.next.disabled,
.pagy-nav-js .page.prev.disabled,
.pagy-nav-js .page.next.disabled {
  @apply text-gray-400 cursor-default;
  &:hover {
    @apply text-gray-400 bg-gray-200;
  }
  &:active {
    @apply text-gray-400 bg-gray-200;
  }
}

.pagy-nav .page.active,
.pagy-nav-js .page.active {
  @apply text-white cursor-default bg-gray-400;
  &:hover {
    @apply text-white bg-gray-400;
  }
  &:active {
    @apply bg-gray-400 text-white;
  }
}


.pagy-combo-nav-js {
  @apply flex max-w-max rounded-full px-3 py-1 text-sm text-gray-500 font-semibold bg-gray-200 shadow-md;
}

.pagy-combo-nav-js .pagy-combo-input {
  @apply bg-white px-2 rounded-sm
}

.pagy-combo-nav-js .page.prev,
.pagy-combo-nav-js .page.next {
  &:hover {
    @apply text-gray-800;
  }
  &:active {
    @apply text-gray-800;
  }
}

.pagy-combo-nav-js .page.prev.disabled,
.pagy-combo-nav-js .page.next.disabled {
  @apply text-gray-400 cursor-default;
}
```
