
// Clone and remove data-pagy and href that are already tested with ruby
export function snapIds(ids:string[]) {
    cy.get("#records").snapshot();
    for (const id of ids) {
        const el = cy.get(id).then($el => {
            const hel = <HTMLElement>$el.get(0).cloneNode(true);
            hel.removeAttribute('data-pagy');
            for (const a of hel.querySelectorAll('a[href]')) { a.removeAttribute('href') }
            return hel;
        })
        el.snapshot();
        // cy.get(id).snapshot();
    }
}

interface TestNavOpts {
    path?:string
    pages?:string[]
    rjs?:boolean
}

export function testNav(app:string, id:string, {path = "/", pages = ["3", "50"], rjs = false}:TestNavOpts) {
    it(`Test ${id}`, () => {
        if (rjs) {
            const widths = [600, 700];
            for (const width of widths) {
                cy.viewport(width, 1000);
                cy.visit(path);
                checkNav(id, pages);
            }
        } else {
            checkNav(id, pages);
        }
    });
}

function checkNav(id:string, pages:string[]) {
    snapIds([id]);
    goCheckNext(id);
    for (const page of pages) {
        cy.get(id).contains(page).click();
        snapIds([id]);
    }
    goCheckPrev(id);
}

export function testComboNav(app:string, id:string) {
    const id_input = `${id} input`;
    it(`Test ${id}`, () => {
        snapIds([id]);
        goCheckNext(id);
        const page = "3";
        cy.get(id_input).type(`${page}{enter}`);
        snapIds([id]);
        for (const invalid of ["abcd", 1000]) {
            cy.get(id_input).type(`${invalid}{enter}`);
            cy.get(id_input).should(($input) => {
                expect($input.val()).not.to.eq(invalid);
                expect($input.val()).to.eq(page);
            }).location().should(loc => expect(loc.href).to.match(new RegExp(`page=${page}`)));
        }
        cy.get(id_input).type("50");
        cy.get(id_input).blur();
        snapIds([id]);
        cy.get(id_input).focus();
        cy.get(id_input).type("{downarrow}{enter}");
        snapIds([id]);
        goCheckPrev(id);
    });
}

export function testLimitSelector(app:string, id:string, path = "/") {
    it(`Test ${id}`, () => {
        const pages    = [1, 36, 50];
        const id_input = `${id} input`;
        for (const page of pages) {
            cy.visit(`${path}?page=${page}`);
            snapIds([id]);
            if (page === 36) {
                for (const invalid of ["abcd", 1000]) {
                    cy.get(id_input).type(`${invalid}{enter}`);
                    cy.get(id_input).should(($input) => {
                        expect($input.val()).not.to.eq(invalid);
                    }).location().should(loc => expect(loc.href).to.match(new RegExp(`page=${page}`)));
                }
            }
            cy.get(id_input).type("10{enter}");
            snapIds([id]);
            cy.get(id_input).type("17");
            cy.get(id_input).blur();
            snapIds([id]);
            cy.get(id_input).focus();
            cy.get(id_input).type("{uparrow}{enter}");
            snapIds([id]);
            // test page after changing limit
            cy.visit(`${path}?page=2&limit=10`);
            cy.location().should(loc => expect(loc.href).to.match(/page=2/));
            cy.get("#limit-tag-js input").type("5{enter}");
            cy.location().should(loc => expect(loc.href).to.match(/page=3/));
        }
    });
}

export function testInfo(app:string, id:string, path = "/") {
    it(`Test ${id}`, () => {
        const pages = [1, 36, 50];
        for (const page of pages) {
            cy.visit(`${path}?page=${page}`);
            snapIds([id]);
        }
    });
}

export function goCheckNext(id:string) {
    cy.get(id).contains(">").click();
    snapIds([id]);
}

export function goCheckPrev(id:string) {
    cy.get(id).contains("<").click();
    snapIds([id]);
}
