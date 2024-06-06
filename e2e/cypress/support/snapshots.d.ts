// add a minimal declaration file
declare module "@cypress/snapshot" {
    global {
        namespace Cypress {
            interface Chainable {
                // Missing declaration from snapshots
                snapshot(opts?:Partial<ObjectLike>):void;
            }
        }
    }
}
