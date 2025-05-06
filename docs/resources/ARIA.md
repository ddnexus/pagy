---
label: ARIA
icon: accessibility
order: 60
---

# 

## ARIA Attributes

---

Since version `7.0.0`, Pagy introduced a consistent set of ARIA-compliant attributes across all its helpers.

+++ Nav helpers

Pagy provides a customizable `aria-label` for the root element of its helpers. It is usually a `nav` element. For
the few helper styles that use a different root element, Pagy adds a `role="navigation"` attribute.

The default string for the `aria-label` of the root element is "Page" / "Pages" (translated and pluralized according to the total
number of pages). This is arguably a better description of the navigation content than just "Pagination" (which is also difficult
to translate in certain languages).

!!!success Help us with your languages!
Please, check the `pagy.aria_label.nav` in the [locale files](https://github.com/ddnexus/pagy/tree/master/gem/locales)
used by your app to ensure correctness in translation and pluralization. If it isn't, please post your translation in the issue linked
within the file. Thank you!
!!!

!!!danger Don't rely on ARIA default with multiple nav elements!

The `nav` elements are `landmark  roles`, and should be distinctly labeled.

!!!success Override the default `:aria_label`s for multiple navs with distinct values!

```erb
<%# Explicitly set the aria_label %>
<%== @pagy.series_nav(aria_label: 'Search result pages') %>
```

!!!


+++ Links

- Links to the previous and next pages are rendered as "&lt;" and "&gt;" and are aria-labelled as translated `"Previous"`
  and `"Next"`. You can customize both the link text and the `aria-label` by editing the `pagy.prev`, `pagy.next`,
  `pagy.aria_label.prev`, and `pagy.aria_label.next` values in the locale files.

- By design, page links do not include an `aria-label` attribute because their text is a simple number (read by screen readers in
  the user's native language), making an explicit attribute redundant and inefficient.

- Disabled links include the `aria-disabled="true"` attribute.
- The current page is marked with the `aria-current="page"` attribute.
- The `role="link"` attribute is applied to link elements in styles that lack an `a` tag or a `href` attribute.
- The `role="separator"` is applied to the `:gap`.
+++
