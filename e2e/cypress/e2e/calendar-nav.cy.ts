// @ts-expect-error TS2835: Relative import paths ... cypress is fine with it
import {navsLoop, stylesCal} from "../support/test-helper";

describe("Test all calendar navs for all styles", () => {
    navsLoop(stylesCal);
});
