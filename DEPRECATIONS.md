# DEPRECATIONS

The helpers for all the frontend extras have been renamed in a more consistent way, following the same convention of the other extras.

## Renaming convenction

The method naming for the frontend extras follow the pattern: `<pagy-prefix>_<name-of-framework>_<qualifier>\_<result>` where:

- pagy-prefix: "pagy"
- name-of-framework: e.g. "bootstrap"
- qualifier: (optional) e.g."compact"
- result: e.g. "nav"

**Notice**: this convention applies only to the frontend extras.

## Renamed methods and files

The following methods (and one file) have been renamed and they will be removed in version 2.0. You only need to search and replace, because the funtionality has not been changed.

### Bootstrap Extra

| Legacy Name                     | New Name                        |
|:--------------------------------|:--------------------------------|
| `pagy_nav_bootstrap`            | `pagy_bootstrap_nav`            |
| `pagy_nav_compact_bootstrap`    | `pagy_bootstrap_compact_nav`    |
| `pagy_nav_responsive_bootstrap` | `pagy_bootstrap_responsive_nav` |

### Bulma Extra

| Legacy Name                 | New Name                    |
|:----------------------------|:----------------------------|
| `pagy_nav_bulma`            | `pagy_bulma_nav`            |
| `pagy_nav_compact_bulma`    | `pagy_bulma_compact_nav`    |
| `pagy_nav_responsive_bulma` | `pagy_bulma_responsive_nav` |

### Foundation Extra

| Legacy Name                      | New Name                         |
|:---------------------------------|:---------------------------------|
| `pagy_nav_foundation`            | `pagy_foundation_nav`            |
| `pagy_nav_compact_foundation`    | `pagy_foundation_compact_nav`    |
| `pagy_nav_responsive_foundation` | `pagy_foundation_responsive_nav` |

### Materialize Extra

| Legacy Name                       | New Name                          |
|:----------------------------------|:----------------------------------|
| `pagy_nav_materialize`            | `pagy_materialize_nav`            |
| `pagy_nav_compact_materialize`    | `pagy_materialize_compact_nav`    |
| `pagy_nav_responsive_materialize` | `pagy_materialize_responsive_nav` |

### Navs Extra

| Legacy Name                  | New Name                            |
|:-----------------------------|:------------------------------------|
|                              | `pagy_plain_nav` (`pagy_nav` alias) |
| `pagy_nav_compact`           | `pagy_plain_compact_nav`            |
| `pagy_nav_responsive`        | `pagy_plain_responsive_nav`         |
| `require "pagy/extras/navs"` | `require "pagy/extras/plain"`       |

### Semantic Extra

| Legacy Name                    | New Name                       |
|:-------------------------------|:-------------------------------|
| `pagy_nav_semantic`            | `pagy_semantic_nav`            |
| `pagy_nav_compact_semantic`    | `pagy_semantic_compact_nav`    |
| `pagy_nav_responsive_semantic` | `pagy_semantic_responsive_nav` |

## Renamed classes and params in helpers

**Notice**: You can skip this section if you did not override any nav helper.

### CSS nav classes

The `nav` CSS classes follow the same renaming rules of the helper methods. For example:

`pagy-nav-responsive-bootstrap` is now `pagy-bootstrap-responsive-nav`

### CSS JSON tag classes

All the JSON tag classes are now `pagy-json`, and the qualifier of the json (e.g. `compact`, `responsive`, ...) is now passed as the first argument in the array content. For example:

`<script type="application/json" class="pagy-responsive-json">["#{id}", ...`

is now

`<script type="application/json" class="pagy-json">["responsive", "#{id}", ...`

However the tags have been refactored to use the shared `pagy_json_tag` helper. For example:

`script = pagy_json_tag(:responsive, id, tags,  responsive[:widths], responsive[:series])`
