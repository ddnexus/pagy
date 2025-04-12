import {testNav, testComboNav, testInfo, testLimitSelector} from "../support/test-helper.ts";

const app = "rails";

describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav(app, "#series-nav", {pages: ["3"]});
    testNav(app, "#series-nav-js", {pages: ["3"]});
    testComboNav(app, "#input-nav-js");
    testLimitSelector(app, "#limit-tag-js");
    testInfo(app, "#pagy-info");
});
