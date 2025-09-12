# Pagy Contributions

> [!IMPORTANT]
> Pagy is imminently moving towards [v43](https://rubygems.org/gems/pagy/versions/43.0.0.rc4). As a result:
> - Please make PRs to the `master-pre` branch unless you are fixing a bug on the `master` branch.
> - If the fixes are portable between the `master` and `master-pre` - it would be ideal if two PRs were submitted.
> - Please raise a discussion re: the above, before starting a PR - because nobody wants to see your work going to waste.

Pull Requests are welcome!

Here are a few useful information for contributing:

1. If you are planning for a complex PR, we suggest that you check before hand whether your
   proposed changes are going to be accepted by posting your ideas in
   the [Feature Requests](https://github.com/ddnexus/pagy/discussions/categories/feature-requests) discussion area
2. For adding translations of locale dictionary files please follow
   the [locales  readme instructions here](https://github.com/ddnexus/pagy/blob/master/gem/locales/README.md).
3. **Pagy repo setup**
    - Clone pagy: `git clone https://github.com/ddnexus/pagy && cd pagy`
    - [Configure the git-hooks](https://github.com/ddnexus/pagy/tree/master/scripts/hooks)
4. **Development**
    - Please create your own branch out of `master` and use it for you development and PR
    - Ensure you are basing your PR on the `master` branch and keep rebasing it on `master` when it changes
    - **Code**
       - You can have a decent development environment already setup by just using one of the apps in
      the [Pagy Playground](https://ddnexus.github.io/pagy/sandbox/playground) and/or
      with the [Pagy::Console](https://ddnexus.github.io/pagy/sandbox/console/) directly from the repo
    - **Docs**
      - The docs run on retype, and the repo is configured for its linux package. You may want to install the [platform specific npm package](https://retype.com/guides/getting-started/#platform-specific) in order to use it
      - `cd` in the pagy root directory
      - Install [bun](https://bun.sh/docs/installation)
      - Run `bun install`
      - Run `retype start`
      - Point your browser at `http://localhost:5000/pagy` for real-time feedback
5. **Testing**
    - If your PR **does not add any new feature** (e.g. a fix), please, just ensure that the "All checks have passed" indicator gets
      green light on the PR page (if it's not enabled, a maintainer will enable it for you)
    - If your PR **adds new features**, it needs [Ruby testing](https://github.com/ddnexus/pagy/tree/master/test) and/or
      [E2E testing](https://github.com/ddnexus/pagy/tree/master/e2e) or the coverage will fail. Ask for support if you need
      assistance.

Thank you!
