// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

import "cypress-html-validate/dist/commands";
require("cypress-dark");
// eslint-disable-next-line @typescript-eslint/no-var-requires
require("@cypress/snapshot").register();

afterEach(() => {
    cy.htmlvalidate();
});

declare global {
    // eslint-disable-next-line @typescript-eslint/no-namespace
    namespace Cypress {
        interface Chainable {
            // missing from snapshots
            snapshot(opts?:Partial<ObjectLike>):void;
        }
    }
}
