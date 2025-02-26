---
title: pagy 🐸 Instance
icon: mention
order: 80
categories:
  - Methods
---

The `@pagy` instance provides all the helpers, navs and components methods you need.

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

==- Common URL Options

- `absolute: true`
  - URL absolute
- `fragment: '#...'`
  - URL fragment string. (It the must include the leding `"#"`!)

=== Methods

[:icon-list-unordered: data_hash](instance/data_hash.md)<br/>
[:icon-list-unordered: headers_hash](instance/headers_hash.md)<br/>
[:icon-list-unordered: links_hash](instance/links_hash.md)<br/>
[:icon-arrow-right: page_url](instance/page_url.md)<br/>
[:icon-code: nav_tag](instance/nav_tag.md)<br/>
[:icon-code: nav_js_tag](instance/nav_is_tag.md)<br/>
[:icon-code: combo_nav_js_tag](instance/combo_nav_js_tag.md)<br/>
[:icon-code-square: info_tag](instance/info_tag.md)<br/>
[:icon-code-square: limit_selector_is_tag.md](instance/limit_selector_is_tag.md)<br/>
[:icon-code-square: a_tags.md](instance/a_tags.md)<br/>
