---
title: pagy 🐸 Methods
icon: mention
order: 80
categories:
  - Methods
---

The `@pagy` instance provides all the helpers, navs and components methods you need.

The instance class is determined by the paginator used, and you can safely ignore it. Just use its methods.

==- Common Nav Options

- `id: 'my-nav'`:
  - Set the `id` HTML attribute of the `nav` tag.
- `aria_label: 'My Label'`:
  - Override the default `pagy.aria_label.nav` string of the `aria-label` attribute. (Use an already pluralized string).

!!!danger Don't rely on ARIA default with multiple nav elements!

The `nav` elements are `landmark  roles`, and should be distinctly labeled.

!!!success Override multiple navs' default with distinct `aria_label`s!

```erb
<%# Explicitly set the aria_label %>
<%== @pagy.nav_tag(aria_label: 'Search result pages') %>
```

!!!

See [ARIA](../resources/aria.md)

==- Common URL Options

- `absolute: true`
  - URL absolute
- `fragment: '#...'`
  - URL fragment string. (It the must include the leding `"#"`!)

=== Methods

[:icon-list-unordered: data_hash](methods/data_hash.md)<br/>
[:icon-list-unordered: headers_hash](methods/headers_hash.md)<br/>
[:icon-list-unordered: links_hash](methods/links_hash.md)<br/>
[:icon-arrow-right: page_url](methods/page_url.md)<br/>
[:icon-code: nav_tag](methods/nav_tag.md)<br/>
[:icon-code: nav_js_tag](methods/nav_is_tag.md)<br/>
[:icon-code: combo_nav_js_tag](methods/combo_nav_js_tag.md)<br/>
[:icon-code-square: info_tag](methods/info_tag.md)<br/>
[:icon-code-square: limit_selector_is_tag.md](methods/limit_selector_is_tag.md)<br/>
[:icon-code-square: a_tags.md](methods/a_tags.md)<br/>
