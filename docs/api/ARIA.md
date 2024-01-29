---
title: ARIA Attributes
categories: 
- Feature
---

# ARIA Attributes

Since version `7.0.0` pagy has introduced a consistent set of ARIA compliant attributes in all its `nav` helpers.

## Nav helpers

Pagy provides the instance-customizable `aria-label` for the root element of the helpers. It is usually a `nav` element, but for the few helper styles that use a different root element, pagy adds a `role="navigation"` attribute to it. 

The default string for the `aria-label` of the root element is "Page"/"Pages". It is translated and pluralized according to the total page number. "Page"/"Pages" is arguably a better description of its content than just "Pagination" (also difficult to translate in certain languages).

Since the `nav` or `role="navigation"` elements of a HTML document are considered `landmark  roles`, they should be uniquely aria-identified in the page. If you use more than one pagy helper in the same page, you should not rely on the default (that would otherwise generate a non-valid document), instead, you should pass either your own (possibly translated and pluralized) `aria-label` string or an i18n-key that locate the translated and pluralized string in your dictionary file. For example:

```erb
<%# Explicitly set the page_label string %> 
<%== pagy_nav(@pagy, page_label: 'Search result pages') %>

<%# I18n key in a dictionary file (pluralized entry) %>
<%== pagy_nav(@pagy, page_i18n_key: 'my.pagy_nav.aria_label') %>
```
## Links

- Links to the previous and next pages are rendered as "&lt;" and "&gt;" and are aria-labelled as translated `"Prev"` and `"Next"`.
- The page numbers don't have any `aria-label` attribute, since their text is a simple number (read by the readers) and an explicit attribute would be redundant and performance inefficient.
- All the disabled links have the `aria-disabled="true"` attribute.
- The current page has the `aria-current="page"` attribute.
- The `role="link"` is added to the link elements of the styles that don't use an `a` element or don't have a `href` attribute.
