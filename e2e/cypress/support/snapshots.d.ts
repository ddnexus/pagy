// add a minimal declaration file
declare module "@cypress/snapshot" {
    global {
        // eslint-disable-next-line @typescript-eslint/no-namespace
        namespace Cypress {
            interface Chainable {
                // Missing declaration from snapshots
                snapshot(opts?:Partial<ObjectLike>):void;
            }
        }
    }
}

