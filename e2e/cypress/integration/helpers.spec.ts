describe("Test generic helpers", () => {
    const pages = [1, 5, 36, 50];

    it("Test pagy_info", () => {
        const id = "#pagy-info";
        for (const page of pages) {
            cy.visit(`/navs?page=${page}`);
            cy.snapId(id);
        }
    });
    it("Test pagy_items_selector_js", () => {
        const id = "#items-selector-js";
        const id_input = `${id} input`;

        for (const page of pages) {
            cy.visit(`/navs?page=${page}`);
            cy.snapId(id);
            cy.get(id_input).type("10{enter}");
            cy.snapId(id);
            cy.get(id_input).type("17").blur();
            cy.snapId(id);
            cy.get(id_input).focus().type("{uparrow}{enter}");
            cy.snapId(id);
        }
    });
});
