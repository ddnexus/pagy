describe("Test behavior of input based helpers", () => {

    const invalids = ["1000", "abcdef"];
    const pages = ["1", "5"];

    for (const invalid of invalids) {
        it("Test input in #items-selector-js", () => {
            cy.visit(`/navs?page=1`)
              .get("#items-selector-js input").type(`${invalid}{enter}`)
              .should(($input) => {
                  expect($input.val()).not.to.eq(invalid);
                  expect($input.val()).to.eq("20");
              }).location().should(loc => expect(loc.href).to.match(new RegExp(`page=1`)));
        });

        for (const page of pages) {
            for (const invalid of invalids) {
                it(`Test input in #combo-nav-js at page ${page}`, () => {
                    cy.visit(`/navs?page=${page}`)
                      .get("#combo-nav-js input").type(`${invalid}{enter}`)
                      .should(($input) => {
                          expect($input.val()).not.to.eq(invalid);
                          expect($input.val()).to.eq(page);
                      }).location().should(loc => expect(loc.href).to.match(new RegExp(`page=${page}`)));
                });
            }
        }
    }
});
