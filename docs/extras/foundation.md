---
title: Foundation
categories:
- Frontend
- Extra
image: null
---

# Foundation Extra

Add nav helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html).

## Synopsis

||| pagy.rb (initializer)

```ruby
require 'pagy/extras/foundation'
```

|||

||| View (helper)

```erb
<%== pagy_foundation_nav(@pagy, **vars) %>
<%== pagy_foundation_nav_js(@pagy, **vars) %>
<%== pagy_foundation_combo_nav_js(@pagy, **vars) %>
```

|||

See [Javascript](/docs/api/javascript.md) if you use `pagy_foundation_nav_js` or `pagy_foundation_combo_nav_js`.

## Files

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)

## Methods

=== `pagy_foundation_nav(pagy)`

![Foundation Nav](/docs/assets/images/foundation_nav.png)

This method is the same as the `pagy_nav`, but customized for Foundation.

See the [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars) documentation.

=== `pagy_foundation_nav_js(pagy, **vars)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_foundation_nav_js` looks like the `pagy_foundation_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation
for more information.

=== `pagy_foundation_combo_nav_js(pagy, **vars)`

![Foundation Combo Nav JS](/docs/assets/images/foundation_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

===
