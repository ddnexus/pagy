describe('Validate the HTML of all calendar the styles helpers', () => {
  const pages = [1, 13, 26]
  const styles = Cypress.env("STYLES")
  for (let s = 0; s < styles.length; s++) {
    let style = `${styles[s]}-calendar`;
    for (let p = 0; p < pages.length; p++) {
      let page = pages[p];
      it('Test valid HTML for ' + style + ' page: ' + page, () => {
        cy.visit(style + '?month_page=' + page);
        cy.htmlvalidate();
      });
    }
  }
})
