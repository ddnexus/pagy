// ***********************************************************
// This example support/e2e.ts is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off (false)
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

import "cypress-html-validate/dist/commands";
import * as cypressSnapshots from "@cypress/snapshot";
// @ts-expect-error: register does not exist
cypressSnapshots.register(); // eslint-disable-line  @typescript-eslint/no-unsafe-call
afterEach(() => cy.htmlvalidate());
// Silence issue https://github.com/quasarframework/quasar/issues/2233#issuecomment-1006506083
// Cypress issue (open) https://github.com/cypress-io/cypress/issues/20341
Cypress.on("uncaught:exception", err => !err.message.includes("ResizeObserver"));
