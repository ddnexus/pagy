/// <reference types="cypress" />

describe('Dummy Test', () => {
  it('toMatchSnapshot - HTML', () => {
    cy.visit('/')
      .then(() => {
        cy.get('#site-map').toMatchSnapshot();
      });
  });
})

