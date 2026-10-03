`keyset: {...}`
: Set it only to force the `keyset` hash of column/order pairs. _(It is set automatically from the set order)_

`tuple_comparison: true`
: Enable the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction order, hence, it's ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL` columns).

`pre_serialize: serialize`
: Set it to a `lambda` that receives the `keyset_attributes` hash. Modify this hash directly to customize the serialization of specific values (e.g., to preserve `Time` object precision). The lambda's return value is ignored.
    ```ruby
    serialize = lambda do |attributes|
      # Convert it to a string matching the stored value/format in SQLite DB
      attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
    end
    ```

{{ include "paginator" }}