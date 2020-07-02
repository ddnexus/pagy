---
title: Tailwind
---
# Tailwind Extra Styles

Tailwind allows to apply styles to any DOM element, so - if you use it - you don't actually need a special extra to produce a different output. You can use the standard unstyled pagy helpers: i.e. the default `pagy_nav` and the `pagy_nav_js`and `pagy_nav_combo_js` provided by the [navs](navs.md) extra, and apply the styles to their classes.

## Synopsis

See the [navs](navs.md) extra if you use `pagy_nav_js` or `pagy_combo_nav_js`.

Copy and customize the following basic rules to apply the styles to the pagy CSS classes:

```scss
.pagy-nav, 
.pagy-nav-js,
.pagy-combo-nav-js {
  @apply .inline-flex .shadow-md;
}
.pagy-nav.pagination, 
.pagy-nav-js.pagination,
.pagy-combo-nav-js.pagination {
  @apply .border .border-gray-600 .rounded-sm;
}
.pagy-nav .page,
.pagy-nav-js .page,
.pagy-combo-nav-js .page,
.pagy-combo-nav-js .pagy-combo-input {
  @apply .text-gray-700 .border-r .border-gray-600 .px-3 .py-2 .text-sm .leading-tight .font-medium;
}
.pagy-nav .page:hover,
.pagy-nav-js .page:hover {
  @apply .text-gray-900;
}
.pagy-nav .disabled,
.pagy-nav-js .disabled,
.pagy-combo-nav-js .disabled {
  @apply .cursor-not-allowed;
}
.pagy-nav .active,
.pagy-nav-js .active {
  @apply .text-blue-500;
}
.pagy-nav .prev,
.pagy-nav-js .prev,
.pagy-combo-nav-js .prev {
  @apply .text-gray-900;
}
.pagy-nav .next,
 .pagy-nav-js .next,
 .pagy-combo-nav-js .next {
  @apply .text-gray-900 .border-r .border-transparent;
}
```
