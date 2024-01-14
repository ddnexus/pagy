// @ts-expect-error TS2835: Relative import paths ... cypress is fine with it
import {navsLoop, styles} from "../support/test-helper";

describe("Test all navs for all styles", () => {
    navsLoop(styles);
});
