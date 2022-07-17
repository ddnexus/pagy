---
title: AJAX
image: null
order: 1
---
# Using AJAX

If you AJAX-render any of the javascript helpers mentioned above, you should also execute `Pagy.init(container_element);` in the javascript template. Here is an example for an AJAX-rendered `pagy_bootstrap_nav_js`:

In `pagy_remote_nav_js` controller action (notice the `link_extra` to enable AJAX):

```ruby
def pagy_remote_nav_js
  @pagy, @records = pagy(Product.all, link_extra: 'data-remote="true"')
end
```

In `pagy_remote_nav_js.html.erb` template for non-AJAX render (first page-load):

```erb
<div id="container">
  <%= render partial: 'nav_js' %>
</div>
```

In `_nav_js.html.erb` partial shared for AJAX and non-AJAX rendering:

```erb
<%== pagy_bootstrap_nav_js(@pagy) %>
```

In `pagy_remote_nav_js.js.erb` javascript template used for AJAX:

```js
$('#container').html("<%= j(render 'nav_js')%>");
Pagy.init(document.getElementById('container'));
```

**IMPORTANT**: The `document.getElementById('container')` argument will re-init the pagy elements just AJAX-rendered in the container div. If you miss it, it will not work.
