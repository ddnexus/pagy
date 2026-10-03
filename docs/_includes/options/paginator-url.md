`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`. Use it to handle multiple pagination objects in the same request.

`page_key: 'my_page'`
: Set it to change the key string used for the `:page` in URLs (default `'page'`).

`limit_key: 'my_limit'`
: Set it to change the key string used for the `:limit` in URLs (default `'limit'`).