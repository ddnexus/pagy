import {testNav} from "../support/test-helper.ts";

const app = "keynav";

describe(`[${app}] Test helpers`, () => {
    beforeEach(() => {
        cy.visit("/");
    });
    let pages = [...Array(13).keys()].map((n) => (n + 1).toString())
    pages.push("10", "13"); // jump back and forth
    testNav(app, "#series-nav", {pages});
    testNav(app, "#series-nav-js-responsive", {pages, rjs: true});
});
