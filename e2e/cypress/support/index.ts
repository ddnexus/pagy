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

import "./commands";
import "cypress-html-validate/dist/commands";
require("cypress-dark");
// eslint-disable-next-line @typescript-eslint/no-var-requires
require("@cypress/snapshot").register();

declare global {
    // eslint-disable-next-line @typescript-eslint/no-namespace
    namespace Cypress {
        interface Chainable {

            // missing from snapshots
            snapshot(opts?:Partial<ObjectLike>):void;

            /**
             * Takes HTML snapshots of the __#records__ and the __id__ elements
             * @param id
             * id selector string (e.g.: '#pagy-info' )
             * @example
             * cy.snapId("#items-selector-js")
             */
            snapId(id:string):void;

            /**
             * Visit the frontend __style__ page, uses the pagination
             * bar (__id__) to navigate to different page numbers
             * and take a few __snapId__ in order to ensure the proper result
             * @param style
             * CSS flavor page path (e.g."/bootstrap")
             * @param id
             * id selector string of the navigation bar (e.g.: '#nav-js' )
             * @param calendar
             * is it a calendar nav?
             * @example
             *  cy.navStyleId('/bootstrap', '#nav-js-responsive', false)
             */
            navStyleId(style:string, id:string, calendar:boolean):void;

            /**
             * Visit the frontend __style__ page, use the __#combo-nav-js__ to navigate to different page numbers
             * and take a few __snapId__ in order to ensure the proper result
             * @param style
             * CSS flavor page path (e.g."/materialize")
             * @example
             * cy.comboNavStyle("/materialize")
             */
            comboNavStyle(style:string):void;
        }
    }
}
