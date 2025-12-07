# Ruby Test Environment

Ruby is tested with [`minitest`](https://github.com/minitest/minitest) through `rake` tasks. It also uses [
`rematch`](https://github.com/ddnexus/rematch) as a snapshot system.

## Prerequisite

- Install the gems: `bundle install`

### Rake tasks

If you want to run all code tests use the `:test` or `test_cov` task. For the full suite (including rubocop coverage and other checks), you can
just run `rake default` (or just `rake`).

---

See also the [E2E Test Environment](https://github.com/ddnexus/pagy/tree/master/e2e).
