import {snapIds} from "../support/test-helper.ts";


const calIds = ["#year-nav", "#month-nav", "#day-nav", "#pagy-info"];

describe(`Test helpers [calendar]`, () => {
    beforeEach(() => {
        cy.visit("/");
    });

    it("Test #toggle", () => {
        snapIds(calIds);
        cy.get("#toggle").click();
        snapIds(["#pages-nav"]);
        cy.get("#toggle").click();
        snapIds(calIds);
    });

    it("Test #go-to-day", () => {
        cy.get("#go-to-day").click();
        snapIds(calIds);
    });

    it("Test calendar navs", () => {
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
