export const navIds = ["#nav", "#nav-js"];
const widths = [500, 750, 1000];
const specialStylesRe = /^\/(bulma)/;

export const styles = [
    "/bootstrap",
    "/bulma",
    "/foundation",
    "/materialize",
    "/navs",
    "/semantic",
    "/uikit"
];

export const stylesCal = styles.map(s => `${s}-calendar`);

export function snapId(id:string) {
    cy.get("#records").snapshot();
    cy.get(id).snapshot();
}

export function navsLoop(styles:string[]) {
    const resp_id = "#nav-js-responsive";
    for (const style of styles) {
        // nav and nav-js
        for (const id of navIds) {
            it(`Test ${style} ${id}`, () => {
                checkStyleId(style, id);
            });
        }
        // nav-js-responsive at different widths
        for (const width of widths) {
            it(`Test ${style} ${resp_id} (${width} width)`, () => {
                cy.viewport(width, 1000);
                checkStyleId(style, resp_id);
            });
        }
    }
}

function checkStyleId(style:string, id:string) {
    const pages = /-calendar$/.test(style)
                  ? ["2022-01", "2023-11"]
                  : ["3", "50"];
    cy.visit(style);
    snapId(id);

    goCheckNext(style, id);
    for (const page of pages) {
        cy.get(id).contains(page).click();
        snapId(id);
    }
    goCheckPrev(style, id);
}

export function goCheckNext(style:string, id:string) {
    specialStylesRe.test(style)
    ? cy.get(id).contains(">").click()
    : cy.get(`${id} a:last`).click();
    snapId(id);
}

export function goCheckPrev(style:string, id:string) {
    specialStylesRe.test(style)
    ? cy.get(id).contains("<").click()
    : cy.get(`${id} a:first`).click();
    snapId(id);
}
