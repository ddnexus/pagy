import {snapIds} from "../support/test-helper.ts";

const app     = "calendar";
const calIds  = ["#year-nav", "#month-nav", "#day-nav", "#pagy-info"];
const envVals = ["true", "false"];

envVals.forEach((val) => {

    describe(`[${app}] Test helpers (skip ${val})`, () => {
        beforeEach(() => {
            cy.visit("/", {qs: { skip_counts: val }});
        });

        it(`Test #go-to-day`, () => {
            cy.get("#go-to-day").click();
            snapIds(calIds);
        });

        it(`Test calendar navs`, () => {
            cy.get("#year-nav").contains("2022").click();
            snapIds(calIds);
            cy.get("#month-nav").contains("Apr").click();
            snapIds(calIds);
            cy.get("#day-nav").contains("05").click();
            snapIds(calIds);
            cy.get("#day-nav").contains("06").click();
            snapIds(calIds);
        });
    });
});

describe(`[${app}] Test app`, () => {
    beforeEach(() => {
        cy.visit("/");
    });
    it(`Test #toggle`, () => {
        snapIds(calIds);
        cy.get("#toggle").click();
        snapIds(["#pages-nav"]);
        cy.get("#toggle").click();
        snapIds(calIds);
    });
});
