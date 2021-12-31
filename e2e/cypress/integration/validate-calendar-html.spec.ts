describe("Validate the HTML of all calendar the styles helpers", () => {
    const styles:string[] = Cypress.env("STYLES").map((s:string) => `${s}-calendar`);
    const pages = [1, 13, 26];

    for (const style of styles) {
        for (const page of pages) {
            it(`Test valid HTML for ${style} page: ${page}`, () => {
                cy.visit(`${style}?month_page=${page}`);
                cy.htmlvalidate();
            });
        }
    }
});
