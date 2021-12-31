describe('Test all navs for all styles', () => {
  const styles:string[] = Cypress.env("STYLES");
  const ids = ['#nav', '#nav-js'];
  const widths = [500, 750, 1000];

  // nav and nav-js\
  for (const style of styles) {
    for (const id of ids) {
      it(`Test ${style} ${id}`, () => {
        cy.navStyleId(style, id, false);
      });
    }
    // nav-js-responsive at different widths
    for (const width of widths) {
      it(`Test ${style} #nav-js-responsive (${width} width)`, () => {
        cy.viewport(width, 1000);
        cy.navStyleId(style, '#nav-js-responsive', false);
      });
    }
    // combo-nav-js
    it(`Test ${style} #combo-nav-js`, () => {
      cy.comboNavStyle(style);
    });
  }
})
