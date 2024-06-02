# Pagy Contributions

Pull Requests are welcome!

Here are a few useful information for contributors:

1. If you are planning for a complex PR, we suggest that you check before hand whether your
   proposed changes are going to be accepted by posting your ideas in
   the [Feature Requests](https://github.com/ddnexus/pagy/discussions/categories/feature-requests) discussion area
2. For adding translations of locale dictionary files please follow
   the [locales  readme instructions here](https://github.com/ddnexus/pagy/blob/master/gem/locales/README.md).
3. **Pagy repo setup**
    - Clone pagy: `git clone https://github.com/ddnexus/pagy && cd pagy`
    - Install the gems: `bundle install`
    - Install node if not present...
    - Optional: install pnpm. It's better if you use corepack to get the right version from package.json
      ([instructions](https://pnpm.io/installation#using-corepack))
    - Install modules: `npm install` (or `pnpm install`)
4. **Development**
    - Please create your own branch out of `master` and use it for you development and PR
    - Ensure you are basing your PR on the `master` branch and keep rebasing it on `master` when it changes
    - **Code**
       - You can have a decent development environment already setup by just using one of the apps in
      the [Pagy Playground](https://ddnexus.github.io/pagy/playground) and/or
      with the [Pagy::Console](https://ddnexus.github.io/pagy/docs/api/console/) directly from the repo
    - **Docs**
      - `cd` in the pagy root directory
      - Run `npm install` or (`pnpm install` if pnpm is installed).
      - Run `retype start`
      - Point your browser at `http://localhost:5000/pagy` for real-time feedback
5. **Testing**
    - If your PR **does not add any new feature** (e.g. a fix), please, just ensure that the "All checks have passed" indicator gets
      green light on the PR page (if it's not enabled, a maintainer will enable it for you)
    - If your PR **adds new features**, it needs [Ruby testing](https://github.com/ddnexus/pagy/tree/master/test) and/or
      [E2E testing](https://github.com/ddnexus/pagy/tree/master/e2e) or the coverage will fail. Ask for support if you need
      assistance.

Thank you!
