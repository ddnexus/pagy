`id: 'my-nav'`
: Set the `id` HTML attribute of the `nav` tag.

`aria_label: 'My Label'`
: Override the default `pagy.aria_label.nav` string of the `aria-label` attribute.<br/>See [ARIA](/resources/aria.md)

  !!!danger
  The `nav` elements are `landmark  roles`, and should be distinctly labeled!

  !!!success
  Override the default `:aria_label`s for multiple navs with distinct values!

  ```erb
  <%# Explicitly set the aria_label %>
  <%== @pagy.series_nav(aria_label: 'Search result pages') %>
  ```