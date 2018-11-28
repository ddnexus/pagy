---
title: Navs
---
# Navs Extra

This extra adds a couple of nav helpers to the `Pagy::Frontend` module: `pagy_nav_compact` and `pagy_nav_responsive`. These are the generic/unstyled helpers for responsive and compact pagination.

Other extras (e.g. [bootstrap](bootstrap.md), [bulma](bulma.md), [foundation](foundation.md), [materialize](materialize.md)) provide framework-styled versions of the same `responsive` and `compact` helpers, so you may not need this extra if you use one of those.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/navs'
```

Configure [javascript](../extras.md#javascript).

## Files

This extra is composed of the [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb) file and uses the shared [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) file.

# Compact navs

The `compact` navs (implemented by this extra or by other frontend extras) add an alternative pagination UI that combines the pagination feature with the navigation info in a single compact element.

It is especially useful for small size screens, but it is used also with wide layouts since it is __even faster__ than the classic nav of links, because it needs to render just a minimal HTML string.

## Synopsis

Use the responsive helper(s) in any view:

```erb
<%== pagy_nav_compact(@pagy) %>
```

Other extras provide also the following framework-styled helpers:

```erb
<%== pagy_bootstrap_compact_nav(@pagy) %>
<%== pagy_nav_compact_bulma(@pagy) %>
<%== pagy_nav_compact_foundation(@pagy) %>
<%== pagy_nav_compact_materialize(@pagy) %>
<%== pagy_nav_compact_semantic(@pagy) %>
```

## Methods

### pagy_nav_compact(pagy, ...)

Renders a compact navigation with a style similar to the `pagy_nav` helper.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you should pass an explicit id only if you are going to use more than one `pagy_nav_compact*` call in the same line for the same page.

# Responsive navs

With the `responsive` navs (implemented by this extra or by other frontend extras) the number of page links will adapt in real-time to the available window or container width.

Here is a screenshot (from the `bootstrap`extra) of how the same pagination nav might look like by resizing the browser window at different widths:

![pagy-responsive](../assets/images/pagy-responsive-g.png)

## Synopsis

```ruby
# set your default custom breakpoints (width/size pairs) globally (it can be overridden per Pagy instance)
Pagy::VARS[:breakpoints] = {0 => [1,2,2,1], 450 => [3,4,4,3], 750 => [4,5,5,4]}
```

Use the responsive helper(s) in any view:

```erb
<%== pagy_nav_responsive(@pagy) %>
```

Other extras provide also the following framework-styled helpers:

```erb
<%== pagy_bootstrap_responsive_nav(@pagy) %>
<%== pagy_nav_responsive_bulma(@pagy) %>
<%== pagy_nav_responsive_foundation(@pagy) %>
<%== pagy_nav_responsive_materialize(@pagy) %>
<%== pagy_nav_responsive_semantic(@pagy) %>
```

## Variables

### :breakpoints

The `:breakpoints` variable is a non-core variable used by the `responsive` navs: it allows you to control how the page links will get shown at different widths. It is a hash where the keys are integers representing the breakpoint widths in pixels and the values are the Pagy `:size` variables to be applied for that width.
 For example:

```ruby
Pagy::VARS[:breakpoints] = {0 => [1,2,2,1], 450 => [3,4,4,3], 750 => [4,5,5,4]}
```

The above statement means that from `0` to `450` pixels width, Pagy will use the `[1,2,2,1]` size, from `450` to `750` it will use the `[3,4,4,3]` size and over `750` it will use the `[4,5,5,4]` size. (Read more about the `:size` variable in the [How to control the page links](../how-to.md#controlling-the-page-links) section)

**IMPORTANT**: You can set any number of breakpoints with any arbitrary width and size. The only requirement is that the `:breakpoints` hash must contain always the `0` size. An `ArgumentError` exception will be raises if it is missing.

**Notice**: Each added breakpoint slowers down Pagy of almost 10%. For example: with 5 breakpoints (which are actually quite a lot) the nav will be rendered rougly in twice the normal time. However, that will still run about 15 times faster than Kaminari and 6 times faster than WillPaginate.

## Methods

### pagy_nav_responsive(pagy, ...)

Similar to the `pagy_nav` helper, with added responsiveness.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you should pass an explicit id if you are going to use more than one `pagy_nav_responsive*` call in the same line for the same file.
