import {testNav, testComboNav, testInfo, testItemsSelector} from "../support/test-helper.ts";


describe(`Test helpers [rails]`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav("#nav", {pages: ["3"]});
    testNav("#nav-js", {pages: ["3"]});
    testComboNav("#combo-nav-js");
    testItemsSelector("#items-selector-js");  // no style, no trim
    testInfo("#pagy-info");
});
