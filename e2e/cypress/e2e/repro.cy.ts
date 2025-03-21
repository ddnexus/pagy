import {testNav, testComboNav, testInfo, testLimitSelector} from "../support/test-helper.ts";

const app = "repro";
describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    testNav(app, "#series-nav", {});
    testNav(app, "#series-nav-js-responsive", {rjs: true});
    testComboNav(app, "#input-nav-js");
    testInfo(app, "#pagy-info");
    testLimitSelector(app, "#limit-tag-js");
});
