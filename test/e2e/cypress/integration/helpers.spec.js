/// <reference types="cypress" />

import { fixCypressSpec } from '../support'
beforeEach(fixCypressSpec(__filename))

describe('Test generic helpers', () => {
  const pages = [1, 5, 36, 50];
  it('test pagy_info', () => {
    const id = '#pagy-info';
    for(let p = 0; p < pages.length; p++) {
      cy.visit('/navs?page=' + pages[p]);
      cy.snapId(id)
    }
  });
  it('test pagy_items_selector_js', () => {
    const id = '#items-selector-js';
    for(let p = 0; p < pages.length; p++) {
      cy.visit('/navs?page=' + pages[p]);
      cy.snapId(id)
      cy.get(id + ' input').type('10{enter}');
      cy.snapId(id);
      cy.get(id + ' input').type('17').blur();
      cy.snapId(id);
      cy.get(id + ' input').focus().type('{uparrow}{enter}');
      cy.snapId(id);
    }
  })
})
