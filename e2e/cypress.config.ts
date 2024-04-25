import {defineConfig} from "cypress";
import * as htmlvalidate from "cypress-html-validate/dist/plugin";

export default defineConfig(
    {
        video: false,
        fixturesFolder: false,
        e2e: {
            // supportFolder: "support",
            baseUrl: "http://0.0.0.0:8080",
            setupNodeEvents(on, config) {
                htmlvalidate.install(on, {
                    rules: {
                        // a few frameworks use improper elements to render various roles
                        "prefer-native-element": "off",
                        // not needed in test environment
                        "require-sri": "off",
                    }
                });
            },
        },
    }
);
