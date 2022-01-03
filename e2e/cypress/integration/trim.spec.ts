import {styles, stylesCal, navIds} from "../support/test-helper";

function trimLoop(styles:string[], ids:string[]) {
    for (const style of styles.map((s) => `${s}/trim`)) {
        const param = /-calendar/.test(style) ? "month_page" : "page";
        for (const url of [style, `${style}?${param}=2`, `${style}?${param}=3`]) {
            it(`Test trimmed links for ${url}`, () => {
                cy.visit(url);
                ids.forEach((id) => cy.get(id).snapshot());
            });
        }
    }
}

describe("Test trim in all helpers and styles", () => {
    trimLoop(styles, [...navIds, "#combo-nav-js"]);
    trimLoop(stylesCal, navIds);
});
