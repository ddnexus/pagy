// @ts-expect-error TS2835: Relative import paths ... cypress is fine with it
import {snapId, goCheckNext, goCheckPrev, styles} from "../support/test-helper";

describe("Test all comboNavs for all styles", () => {
    const id       = "#combo-nav-js";
    const id_input = `${id} input`;

    for (const style of styles) {
        it(`Test ${style} ${id}`, () => {
            cy.visit(style);
            snapId(id);
            goCheckNext(style, id);
            cy.get(id_input).type("3{enter}");
            snapId(id);
            cy.get(id_input).type("50").blur();
            snapId(id);
            cy.get(id_input).focus().type("{downarrow}{enter}");
            snapId(id);
            goCheckPrev(style, id);
        });
    }
});
