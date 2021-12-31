"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
Cypress.Commands.add("snapId", function (id) {
    cy.get("#records").snapshot();
    cy.get(id).snapshot({ json: false });
});
Cypress.Commands.add("navStyleId", function (style, id, calendar) {
    cy.visit(style);
    cy.snapId(id);
    var page1 = calendar ? "2022-01" : "3";
    var page2 = calendar ? "2023-11" : "50";
    var cal_str = calendar ? "-calendar" : "";
    if (style === "/materialize".concat(cal_str) || style === "/semantic".concat(cal_str)) {
        cy.get(id + " a:last").click();
    }
    else {
        cy.get(id).contains("Next").click();
    }
    cy.snapId(id);
    cy.get(id).contains(page1).click();
    cy.snapId(id);
    cy.get(id).contains(page2).click();
    cy.snapId(id);
    if (style === "/materialize".concat(cal_str) || style === "/semantic".concat(cal_str)) {
        cy.get(id + " a:first").click();
    }
    else {
        cy.get(id).contains("Prev").click();
    }
    cy.snapId(id);
});
Cypress.Commands.add("comboNavStyle", function (style) {
    var id = "#combo-nav-js";
    cy.visit(style);
    cy.snapId(id);
    if (style === "/materialize" || style === "/semantic") {
        cy.get(id + " a:last").click();
    }
    else {
        cy.get(id).contains("Next").click();
    }
    cy.snapId(id);
    cy.get(id + " input").type("3{enter}");
    cy.snapId(id);
    cy.get(id + " input").type("50").blur();
    cy.snapId(id);
    cy.get(id + " input").focus().type("{downarrow}{enter}");
    cy.snapId(id);
    if (style === "/materialize" || style === "/semantic") {
        cy.get(id + " a:first").click();
    }
    else {
        cy.get(id).contains("Prev").click();
    }
    cy.snapId(id);
});
