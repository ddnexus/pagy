import {testNav, testComboNav, testInfo, testItemsSelector} from "../support/test-helper.ts";

const paths = [
    "/pagy",
    "/bootstrap",
    "/bulma"
];

for (const path of paths) {
    describe(`Test ${path} helpers [demo]`, () => {
        beforeEach(() => {
            cy.visit(path);
        });

        testNav("#nav", {path: path});
        testNav("#nav-js", {path: path});
        testNav("#nav-js-responsive", {path: path, rjs: true});
        testComboNav("#combo-nav-js");
        testInfo("#pagy-info", path);
        if (path === "/pagy") {
            testItemsSelector("#items-selector-js", path, true); // trim true
        }
    });
}
