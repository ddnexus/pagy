import {testNav, testComboNav, testInfo, testItemsSelector} from "../support/test-helper.ts";

const app = "rails";

describe(`[rails] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav(app, "#nav", {pages: ["3"]});
    testNav(app, "#nav-js", {pages: ["3"]});
    testComboNav(app, "#combo-nav-js");
    testItemsSelector(app, "#items-selector-js");  // no style, no trim
    testInfo(app, "#pagy-info");
});
