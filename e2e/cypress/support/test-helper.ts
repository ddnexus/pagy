const ids = ["#nav", "#nav-js"];
const widths = [500, 750, 1000];
const specialStylesRe = /^\/(materialize|semantic)/;

export const navStyles = [
    "/bootstrap",
    "/bulma",
    "/foundation",
    "/materialize",
    "/navs",
    "/semantic",
    "/uikit"
];

export const calStyles = navStyles.map((s:string) => `${s}-calendar`);

export function snapId(id:string) {
    cy.get("#records").snapshot();
    cy.get(id).snapshot();
}

export function navsLoop(styles:string[]) {
    const resp_id = "#nav-js-responsive";
    for (const style of styles) {
        // nav and nav-js
        for (const id of ids) {
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

    goCheckNext(id, style);
    for (const page of pages) {
        cy.get(id).contains(page).click();
        snapId(id);
    }
    goCheckPrev(id, style);
}

export function goCheckNext(id:string, style:string) {
    specialStylesRe.test(style)
    ? cy.get(`${id} a:last`).click()
    : cy.get(id).contains("Next").click();
    snapId(id);
}

export function goCheckPrev(id:string, style:string) {
    specialStylesRe.test(style)
    ? cy.get(`${id} a:first`).click()
    : cy.get(id).contains("Prev").click();
    snapId(id);
}
