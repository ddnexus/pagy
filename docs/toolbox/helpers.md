---
label: "@pagy.✳ Helpers"
icon: mention
order: 80
categories:
  - Helpers
---

#

## @pagy.<span style="font-size: .65em; vertical-align: middle">✳</span> Helpers

---

The `@pagy` instance provides all the helpers to use in your code.

Its class is determined by the paginator used, but you can safely ignore it. Simply utilize its methods.

!!!success The `@pagy` helpers are autoloaded only if used!

Unused code consumes no memory.
!!!

[:icon-list-unordered: data_hash](helpers/data_hash.md)<br/>
[:icon-list-unordered: headers_hash](helpers/headers_hash.md)<br/>
[:icon-list-unordered: urls_hash](helpers/urls_hash.md)<br/>
[:icon-arrow-right: page_url](helpers/page_url.md)<br/>
[:icon-code: series_nav](helpers/series_nav.md)<br/>
[:icon-code: series_nav_js](helpers/series_nav_js.md)<br/>
[:icon-code: input_nav_js](helpers/input_nav_js.md)<br/>
[:icon-code-square: anchor_tags](helpers/anchor_tags.md)<br/>
[:icon-code-square: info_tag](helpers/info_tag.md)<br/>
[:icon-code-square: limit_tag_js](helpers/limit_tag_js.md)<br/>

==- Common Options

!!!success Helpers can inherit and override options

See [Options](options)
!!!

==- Common Nav Styles

- `:pagy/nil` style (default style)
- `:bootstrap`
  - Set `classes: 'pagination pagination-sm any-class'` style option to override the default `'pagination'` class.
- `:bulma`
  - Set `classes: 'pagination is-small any-class'` style option to override the default `'pagination'` classes.
  
==- Common Nav Options

- `id: 'my-nav'`:
  - Set the `id` HTML attribute of the `nav` tag.
- `aria_label: 'My Label'`:
  - Override the default `pagy.aria_label.nav` string of the `aria-label` attribute. (Use an already pluralized string).

  !!!danger Don't rely on ARIA default with multiple nav elements!
  
  The `nav` elements are `landmark  roles`, and should be distinctly labeled.
  
  !!!success Override the default `:aria_label`s for multiple navs with distinct values!

  ```erb
  <%# Explicitly set the aria_label %>
  <%== @pagy.series_nav(aria_label: 'Search result pages') %>
  ```
  !!!
  Refer to [ARIA](../resources/aria.md) for additional information.

===
