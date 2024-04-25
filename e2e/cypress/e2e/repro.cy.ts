import {testNav, testComboNav, testInfo, testItemsSelector} from "../support/test-helper.ts";


describe(`Test helpers [repro]`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav("#nav", {});
    testNav("#nav-js", {});
    testNav("#nav-js-responsive", {rjs: true});
    testComboNav("#combo-nav-js");
    testInfo("#pagy-info");
    testItemsSelector("#items-selector-js");  // no style, no trim
});
