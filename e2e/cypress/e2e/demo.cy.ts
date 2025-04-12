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

        testNav(app, "#series-nav", {path: path});
        testNav(app, "#series-nav-js-responsive", {path: path, rjs: true});
        testComboNav(app, "#input-nav-js");
        testInfo(app, "#pagy-info", path);
        if (path === "/pagy") {
            testLimitSelector(app, "#limit-tag-js", path);
        }
    });
}
