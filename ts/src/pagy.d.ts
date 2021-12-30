interface Element {
    pagyRender(): void;
}
interface HTMLElement {
    pagyRender(): void;
}
interface NavTags {
    readonly before: string;
    readonly link: string;
    readonly active: string;
    readonly gap: string;
    readonly after: string;
}
interface NavSequels {
    readonly [width: string]: (string | number | "gap")[];
}
interface NavLabelSequels {
    [width: string]: (string | "gap")[];
}
declare const Pagy: {
    version: string;
    init(arg?: any): void;
    nav(pagyEl: Element, tags: NavTags, sequels: NavSequels, opt_label_sequels: null | NavLabelSequels, trimParam?: string | undefined): void;
    throttleRenderNavsTID: number;
    throttleRenderNavsDelay: number;
    throttleRenderNavs(): void;
    renderNavs(): void;
    combo_nav(pagyEl: Element, page: string, link: string, trimParam?: string | undefined): void;
    trim(link: string, param: string): string;
    items_selector(pagyEl: Element, from: number, link: string, trimParam?: string | undefined): void;
    addInputBehavior(input: HTMLInputElement, goToPage: Function): void;
};
