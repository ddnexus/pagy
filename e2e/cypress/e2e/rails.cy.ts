import {testNav, testComboNav, testInfo, testLimitSelector} from "../support/test-helper.ts";

const app = "rails";

describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav(app, "#nav", {pages: ["3"]});
    testNav(app, "#nav-js", {pages: ["3"]});
    testComboNav(app, "#combo-nav-js");
    testLimitSelector(app, "#limit-selector-js");  // no style, no trim
    testInfo(app, "#pagy-info");
});
