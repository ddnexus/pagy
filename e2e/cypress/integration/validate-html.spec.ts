describe("Validate the HTML of all the styles helpers", () => {
    const styles:string[] = Cypress.env("STYLES");
    const pages = [1, 25, 50];

    for (const style of styles) {
        for (const page of pages) {
            it(`Test valid HTML for ${style} page: ${page}`, () => {
                cy.visit(`${style}?page=${page}`);
                cy.htmlvalidate();
            });
        }
    }
});
