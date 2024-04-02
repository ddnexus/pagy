---
title: ARIA Attributes
categories:
  - Feature
---

# ARIA Attributes

Since version `7.0.0` pagy has introduced a consistent set of ARIA compliant attributes in all its `pagy*_nav` helpers.

+++ Nav helpers

Pagy provides the customizable `aria-label` for the root element of its helpers. It is usually a `nav` element, but for
the few helper styles that use a different root element, pagy adds a `role="navigation"` attribute to it.

The default string for the `aria-label` of the root element is "Page" / "Pages" (translated and pluralized according to the total
page number). It's arguably a better description of the nav content than just "Pagination" (also difficult to translate in certain
languages).

!!!success Help us with your languages!
Please, check the `pagy.aria_label.nav` in the [locale files](https://github.com/ddnexus/pagy/tree/master/gem/locales)
used by your app to be already correctly translated and pluralized. If it's not, please, post your translation in the issue linked
in the file itself. Thank you!
!!!

!!!danger Validation
Since the `nav` or `role="navigation"` elements of a HTML document are considered `landmark  roles`, they
should be uniquely aria-identified in the page.

If you use more than one pagy helper in the same page, you should not rely on the default (that would otherwise generate a
non-valid document), instead, you should pass your own (possibly translated and pluralized) `aria-label` string. For example:

```erb
<%# Explicitly set the aria_label string %> 
<%== pagy_nav(@pagy, aria_label: 'Search result pages') %>
```

!!!

+++ Links

- Links to the previous and next pages are rendered as "&lt;" and "&gt;" and are aria-labelled as translated `"Previous"`
  and `"Next"`. You can edit both the link texts and the aria-labels by editing the `pagy.prev`, `pagy.next`,
  `pagy.aria_label.prev` and `pagy.aria_label.next` values in the locale files.
- The page links don't have any `aria-label` attribute by design, because their text is a simple number (read by the readers in
  their native language) and an explicit attribute would be redundant and inefficient.
- All the disabled links have the `aria-disabled="true"` attribute.
- The current page is marked with the `aria-current="page"` attribute.
- The `role="link"` is added to the link elements of the styles that don't use an `a` element or don't have a `href` attribute.

+++
