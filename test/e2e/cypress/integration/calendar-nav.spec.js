describe('Test all calendar navs for all styles', () => {
  const ids = ['#nav', '#nav-js'];
  const widths = [500, 750, 1000];
  const styles = Cypress.env("STYLES");
  // nav and nav-js
  for (let s = 0; s < styles.length; s++) {
    let style = `${styles[s]}-calendar`;
    for (let i = 0; i < ids.length; i++) {
      let id = ids[i]
      it('Test ' + style + ' ' + id, () => {
        cy.navStyleId(style, id, true);
      });
    }
    // nav-js-responsive at different widths
    for (let w = 0; w < widths.length; w++) {
      let width = widths[w]
      it('Test ' + style + ' #nav-js-responsive (' + width + ' width)', () => {
        cy.viewport(width, 1000);
        cy.navStyleId(style, '#nav-js-responsive', true);
      });
    }
  }
})
