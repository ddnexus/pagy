/// <reference types="cypress" />

import { fixCypressSpec } from '../support'
beforeEach(fixCypressSpec(__filename))

describe('Test Bootstrap', () => {
  it('toMatchSnapshot - HTML', () => {
    cy.visit('/bootstrap')
      .then(() => {
        cy.get('#site-map').toMatchSnapshot();
      });
  });

  /* === Test Created with Cypress Studio === */
  it('Try Studio', function() {
    /* ==== Generated with Cypress Studio ==== */
    cy.visit('/bootstrap');
    cy.get('#nav > .pagination > :nth-child(4) > .page-link').click();
    cy.get('#nav-js-responsive > .pagination > :nth-child(8) > .page-link').click();
    cy.get('.text-primary').click();
    cy.get('.text-primary').clear();
    cy.get('.text-primary').type('34{enter}');
    /* ==== End Cypress Studio ==== */
  });
})

