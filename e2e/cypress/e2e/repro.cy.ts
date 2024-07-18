import {testNav, testComboNav, testInfo, testLimitSelector} from "../support/test-helper.ts";

const app = "repro";
describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav(app, "#nav", {});
    testNav(app, "#nav-js", {});
    testNav(app, "#nav-js-responsive", {rjs: true});
    testComboNav(app, "#combo-nav-js");
    testInfo(app, "#pagy-info");
    testLimitSelector(app, "#limit-selector-js");  // no style, no trim
});
