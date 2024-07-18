import {testNav, testComboNav, testInfo, testLimitSelector} from "../support/test-helper.ts";

const app   = "demo";
const paths = [
    "/pagy",
    "/bootstrap",
    "/bulma"
];

for (const path of paths) {
    describe(`[${app}] Test ${path} helpers`, () => {
        beforeEach(() => {
            cy.visit(path);
        });

        testNav(app, "#nav", {path: path});
        testNav(app, "#nav-js", {path: path});
        testNav(app, "#nav-js-responsive", {path: path, rjs: true});
        testComboNav(app, "#combo-nav-js");
        testInfo(app, "#pagy-info", path);
        if (path === "/pagy") {
            testLimitSelector(app, "#limit-selector-js", path, true); // trim true
        }
    });
}
