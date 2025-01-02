import {defineConfig} from "cypress";
import * as htmlvalidate from "cypress-html-validate/dist/plugin";

export default defineConfig(
    {
        video: false,
        fixturesFolder: false,
        e2e: {
            // supportFolder: "support",
            baseUrl: "http://0.0.0.0:8080",
            setupNodeEvents(on) {
                htmlvalidate.install(on, {
                    rules: {
                        // not needed in test environment
                        "require-sri": "off",
                    }
                });
            },
        },
    }
);
