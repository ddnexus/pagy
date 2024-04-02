// @ts-expect-error TS2835: Relative import paths ... cypress is fine with it
import {styles, stylesCal, navIds} from "../support/test-helper";

describe("Test trim in all helpers and styles", () => {
    const testLoop = (styles:string[], ids:string[], param:string) => {
        for (const style of styles) {
            for (const page of [1, 2, 3]) {
                const url = `${style}?trim=true&${param}=${page}`;
                it(`Test trimmed links for ${url}`, () => {
                    cy.visit(url);
                    ids.forEach(id => cy.get(id).snapshot());
                });
            }
        }
    };
    testLoop(styles, [...navIds, "#combo-nav-js"], "page");
    testLoop(stylesCal, navIds, "month_page");

    it("Test the trimmed location.href after using the items_selector", () => {
        cy.visit("/pagy?trim=true&page=1&items=20");
        cy.location().should(loc => expect(loc.href).to.match(/page=1/));
        cy.get("#items-selector-js input").type("19{enter}");
        cy.location().should(loc => expect(loc.href).to.not.match(/page=1/));
    });
});
