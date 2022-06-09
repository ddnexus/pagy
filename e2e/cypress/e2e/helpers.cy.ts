import {snapId} from "../support/test-helper";

describe("Test generic helpers", () => {
    const pages = [1, 5, 36, 50];

    it("Test pagy_info", () => {
        const id = "#pagy-info";
        for (const page of pages) {
            cy.visit(`/navs?page=${page}`);
            snapId(id);
        }
    });
    it("Test pagy_items_selector_js", () => {
        const id = "#items-selector-js";   // eslint-disable-line align-assignments/align-assignments
        const id_input = `${id} input`;

        for (const page of pages) {
            cy.visit(`/navs?page=${page}`);
            snapId(id);
            cy.get(id_input).type("10{enter}");
            snapId(id);
            cy.get(id_input).type("17").blur();
            snapId(id);
            cy.get(id_input).focus().type("{uparrow}{enter}");
            snapId(id);
        }
    });
});
