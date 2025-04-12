---
label: pagy 💚 Methods
icon: mention
order: 80
categories:
  - Methods
---

#

## <span style="font-size: .65em; vertical-align: middle">💚</span> Methods

---

The `@pagy` instance provides methods for every navigation tag and helper to use in your code.

Its class is determined by the paginator used, but you can safely ignore it. Simply utilize its methods.

!!!success The `@pagy` methods are autoloaded only if used!

Unused code consumes no memory.
!!!

[:icon-list-unordered: data_hash](methods/data_hash.md)<br/>
[:icon-list-unordered: headers_hash](methods/headers_hash.md)<br/>
[:icon-list-unordered: links_hash](methods/links_hash.md)<br/>
[:icon-arrow-right: page_url](methods/page_url.md)<br/>
[:icon-code: series_nav](methods/series_nav.md)<br/>
[:icon-code: series_nav_js](methods/series_nav_js.md)<br/>
[:icon-code: input_nav_js](methods/input_nav_js.md)<br/>
[:icon-code-square: anchor_tags](methods/anchor_tags.md)<br/>
[:icon-code-square: info_tag](methods/info_tag.md)<br/>
[:icon-code-square: limit_tag_js](methods/limit_tag_js.md)<br/>


==- Common Nav Styles

- No arguments: default pagy style
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
