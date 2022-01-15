declare type NavArgs = readonly [Tags, Sequels, null | LabelSequels, string?];
declare type ComboArgs = readonly [string, string?];
declare type SelectorArgs = readonly [number, string, string?];
interface Tags {
    readonly before: string;
    readonly link: string;
    readonly active: string;
    readonly gap: string;
    readonly after: string;
}
interface Sequels {
    readonly [width: string]: (string | number | "gap")[];
}
interface LabelSequels {
    readonly [width: string]: string[];
}
interface NavElement extends Element {
    pagyRender(): void;
}
declare const Pagy: {
    version: string;
    init(arg?: Element | never): void;
    initWarn(el: Element, err: unknown): void;
    initNav(el: NavElement, [tags, sequels, labelSequels, trimParam]: NavArgs): void;
    rjsObserver: ResizeObserver;
    initCombo(el: Element, [link, trimParam]: ComboArgs): void;
    initSelector(el: Element, [from, link, trimParam]: SelectorArgs): void;
    initInput(el: Element, getVars: (v: string) => [string, string], trimParam?: string): void;
    trim: (link: string, param: string) => string;
};
export default Pagy;
