---
title: AJAX
image: none
order: 1
---

# Using AJAX

If you AJAX-render any of the javascript helpers mentioned above, you should also execute `Pagy.init(container_element);` in the
javascript template. Here is an example for an AJAX-rendered `pagy_bootstrap_nav_js`:

```ruby Controller
def pagy_remote_nav_js
  # notice the anchor_string to enable Ajax
  @pagy, @products = pagy(collection, anchor_string: 'data-remote="true"')
end
```

```erb "pagy_remote_nav_js.html.erb" - non-AJAX render (first page-load)
<div id="container">
  <%= render partial: 'nav_js' %>
</div>
```

```erb "_nav_js.html.erb" partial - AJAX and non-AJAX rendering
<%== pagy_bootstrap_nav_js(@pagy) %>
```

```js "pagy_remote_nav_js.js.erb" template - AJAX rendering
document.getElementById('container').innerHTML = "<%= j(render 'nav_js')%>";
Pagy.init(document.getElementById('container'));
```

!!!warning Don't forget to re-initialize!

The `document.getElementById('container')` argument will re-init the pagy elements just AJAX-rendered in the container div. If you
miss it, it will not work.
!!!
