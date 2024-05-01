import {snapIds} from "../support/test-helper.ts";

const app = "calendar";
const calIds = ["#year-nav", "#month-nav", "#day-nav", "#pagy-info"];

describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    it(`[${app}] Test #toggle`, () => {
        snapIds(calIds);
        cy.get("#toggle").click();
        snapIds(["#pages-nav"]);
        cy.get("#toggle").click();
        snapIds(calIds);
    });

    it(`[${app}] Test #go-to-day`, () => {
        cy.get("#go-to-day").click();
        snapIds(calIds);
    });

    it(`[${app}] Test calendar navs`, () => {
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
