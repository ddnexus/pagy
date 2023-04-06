---
title: AJAX
image: null
order: 1
---
# Using AJAX

If you AJAX-render any of the javascript helpers mentioned above, you should also execute `Pagy.init(container_element);` in the javascript template. Here is an example for an AJAX-rendered `pagy_bootstrap_nav_js`:


||| Controller 

```ruby
def pagy_remote_nav_js
  # notice the link_extra to enable Ajax
  @pagy, @products = pagy(Product.all, link_extra: 'data-remote="true"')
end
```
|||

||| `pagy_remote_nav_js.html.erb` - non-AJAX render (first page-load):
```erb
<div id="container">
  <%= render partial: 'nav_js' %>
</div>
```
|||

||| `_nav_js.html.erb` partial - AJAX and non-AJAX rendering:
```erb
<%== pagy_bootstrap_nav_js(@pagy) %>
```
|||

||| `pagy_remote_nav_js.js.erb`template - AJAX rendering:


+++ JavaScript
```js
document.getElementById('container').innerHTML = "<%= j(render 'nav_js')%>";
Pagy.init(document.getElementById('container'));
````
+++ JQuery
```js
$('#container').html("<%= j(render 'nav_js')%>");
Pagy.init($('#container')[0]);
```
+++

|||

!!!primary Don't forget to re-initialize!

The `document.getElementById('container')` argument will re-init the pagy elements just AJAX-rendered in the container div. If you miss it, it will not work.
!!!
