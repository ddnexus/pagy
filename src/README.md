# Temporary notes

The `package.json` file contains a couple of temporary fixes for issues in the dependency modules:
 
## Fix 1

```json
"@types/node": "20.8.0"
```

is not the latest, because it would generate a problem using parcel build (`TS2792: Cannot find module 'undici-types'.`)

```json
    "pnpm": {
        "peerDependencyRules": {
            "allowedVersions": {
                "svgo": "2.8.0"
            }
        }
    },
```
   
## Fix 2

Allow the use of `"svgo": "2.8.0"` in order to fix the problem with parcel:

```
WARN Issues with peer dependencies found
src
└─┬ parcel 2.10.3
  └─┬ @parcel/config-default 2.10.3
    └─┬ @parcel/optimizer-htmlnano 2.10.3
      └─┬ htmlnano 2.1.0
        └── ✕ unmet peer svgo@^3.0.2: found 2.8.0 in @parcel/optimizer-htmlnano
```

__Check periodically if the fixes above can be removed.__
