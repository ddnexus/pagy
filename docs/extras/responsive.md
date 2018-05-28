---
title: Responsive
---

# Responsive Extra

With the `responsive` extra the number of page links will adapt in real-time to the available window or container width.

Here is an example of how the same pagination nav might look like by resizing the browser window at different widths:

![pagy-responsive](../assets/images/pagy-responsive-g.png)

## Synopsys

See [extras](../extras.md) for general usage info.

```ruby
# in the initializer
require 'pagy/extra/responsive' 

# set your default custom breakpoints (width/size pairs) globally (it can be overridden per pagy instance)
Pagy::VARS[:breakpoints] = {0 => [1,2,2,1], 450 => [3,4,4,3], 750 => [4,5,5,4]}

# in rails apps: add the assets-path
Rails.application.config.assets.paths << Pagy.root.join('pagy', 'extras', 'javascripts')
```
In rails: add the javascript file to the application.js
```js
//= require pagy-responsive
```
In non-rails apps: ensure the `pagy/extras/javascripts/pagy-responsive.js` script gets served with the page

Then use the responsive helper(s) in any view:

```erb
<%== pagy_nav_responsive(@pagy) %>
<%== pagy_nav_bootstrap_responsive(@pagy) %>
```

## Files

This extra is composed of 2 small files:

- [responsive.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/responsive.rb)
- [pagy-responsive.js](https://github.com/ddnexus/extras/blob/master/lib/pagy/extras/javascripts/pagy-responsive.js)

## Variables

### :breakpoints

The `:breakpoint` variable is a pagy variable added by the `responsive` extra: it allows you to control how the page links will get shown at different widths. It is a hash where the keys are integers representing the breakpoint widths in pixels and the values are the pagy `:size` variables to be applied for that width.
 For example:

```ruby
Pagy::VARS[:breakpoints] = {0 => [1,2,2,1], 450 => [3,4,4,3], 750 => [4,5,5,4]}
```

The above statement means that from `0` to `450` pixels width, pagy will use the `[1,2,2,1]` size, from `450` to `750` it will use the `[3,4,4,3]` size and over `750` it will use the `[4,5,5,4]` size. (Read more about the `:size` variable in the [How to control the page links](../how-to.md#controlling-the-page-links) section)


**IMPORTANT**: You can set any number of breakpoints with any arbitrary width and size. The only requirement is that the `:breakpoints` hash must contain always the `0` size. An `ArgumentError` exception will be raises if it is missing.

## Methods

The `reponsive` extra adds an instance method to the `Pagy` class and couple of nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### responsive

**Notice**: Unless you are going to override a `*_responsive` helper you can ignore this method.

This is a `Pagy` instance method that returns the data structure used by the `*_responsive` helpers in order to build the html and the javascript codes needed to make pagy responsive to different widths.

### pagy_nav_responsive(pagy, ...)

Similar to the `pagy_nav` helper, with added responsiveness.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you should pass an explicit id if you are going to use more than one `*_responsive` call in the same line for the same page.

### pagy_nav_bootstrap_responsive(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for Bootstrap.

| A   | B                             | Links                        |
|:----|:------------------------------|:-----------------------------|
| `a` | Text text text text text text | [a](https://github.com/a.rb) |
| `b` | Text text text text text text | [b](https://github.com/b.rb) |
| `c` | Text text text text text text | [c](https://github.com/c)    |
