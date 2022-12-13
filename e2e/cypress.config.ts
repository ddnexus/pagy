import {defineConfig} from "cypress";
import * as htmlvalidate from "cypress-html-validate/dist/plugin";

export default defineConfig(
    {
        video: false,
        fixturesFolder: false,
        e2e: {
            // supportFolder: "support",
            baseUrl: "http://0.0.0.0:4567",
            setupNodeEvents(on, config) {
                htmlvalidate.install(on, {
                    rules: {
                        // a few frameworks use ul or div for pagination, and aria-role="navigation" will trigger it
                        "prefer-native-element": "off",
                        // not needed in test environment
                        "require-sri": "off"
                    }
                });
            },
        },
    }
);
