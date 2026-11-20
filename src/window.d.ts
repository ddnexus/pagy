import type Pagy from "./pagy.ts"

// The global assigned by pagy-shim.ts
declare global {
  interface Window { Pagy: typeof Pagy }
}
