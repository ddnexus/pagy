import {testNav, testComboNav, testInfo, testItemsSelector} from "../support/test-helper.ts";

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
    testItemsSelector(app, "#items-selector-js");  // no style, no trim
});
