/// <reference types="cypress" />

import {ConfigData} from "html-validate";
/**
 * @type {Cypress.PluginConfig}
 */

// eslint-disable-next-line @typescript-eslint/no-var-requires
const htmlvalidate = require("cypress-html-validate/dist/plugin");

// `on` is used to hook into various events Cypress emits
// `config` is the resolved Cypress config
module.exports = (on:never, config:never) => {
    const htmlConfig:ConfigData = {
        rules: {
            // a few frameworks use ul or div for pagination, and aria-role="navigation" will trigger it
            "prefer-native-element": "off",
            // not needed in test environment
            "require-sri": "off"
        }
    };
    htmlvalidate.install(on, htmlConfig);
    return config;
};
