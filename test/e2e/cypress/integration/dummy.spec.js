/// <reference types="cypress" />

import { fixCypressSpec } from '../support'
beforeEach(fixCypressSpec(__filename))

describe('Dummy Test', () => {
  it('toMatchSnapshot - HTML', () => {
    cy.visit('/')
      .then(() => {
        cy.get('#site-map').toMatchSnapshot();
      });
  });
})

