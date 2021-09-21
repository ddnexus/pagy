declare namespace Cypress {
    interface Chainable<Subject> {

        /**
         * Takes HTML snapshots of the __#records__ and the __id__ elements
         * @param id
         * id selector string (e.g.: '#pagy-info' )
         * @example
         * cy.snapid("#items-selector-js")
         */
        snapId(id: string): Chainable<any>

        /**
         * Visit the frontend __style__ page, uses the pagination
         * bar (__id__) to navigate to different page numbers
         * and take a few __snapId__ in order to ensure the proper result
         * @param style
         * CSS flavor page path (e.g."/bootstrap")
         * @param id
         * id selector string of the navigation bar (e.g.: '#nav-js' )
         * @example
         *  cy.navStyleId('/bootstrap', '#nav-js-responsive')
         */
        navStyleId(style: string, id: string): Chainable<any>

        /**
         * Visit the frontend __style__ page, use the __#combo-nav-js__ to navigate to different page numbers
         * and take a few __snapId__ in order to ensure the proper result
         * @param style
         * CSS flavor page path (e.g."/materialize")
         * @example
         * cy.comboNavStyle("/materialize")
         */
        comboNavStyle(style: string): Chainable<any>
  }
}
