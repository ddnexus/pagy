---
title: Backend Methods
order: 100
---

Include this module in your controller to have the methods to paginate your collections:

```ruby ApplicationController
include Pagy::Backend
```

!!!success Pagy loads ONLY the methods that you actually use

The rest of the pagy code will never use any memory
!!!

!!!warning Don't instantiate any Pagy class directly

Use the paginator methods that know which implementer class to use, and how to initialize it.
!!!
