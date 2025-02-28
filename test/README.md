# Ruby Test Environment

Ruby is tested with [`minitest`](https://github.com/minitest/minitest) through `rake` tasks. It also uses [
`rematch`](https://github.com/ddnexus/rematch) as a snapshot system.

## Prerequisite

- Install the gems: `bundle install`

## Run the Ruby tests

Almost every test recreates a different environment and must run in a separate process to avoid overriding other tests. This means
that you can run a single test file (or a single spec in a test file) and it will work correctly, but you cannot run a directory
of test files with a single minitest command because they will interfere with each other and fail.

### Rake tasks

If you want to run all code tests use the `:test` task. For the full suite (including rubocop coverage and other checks), you can
just run `rake default` (or just `rake`), or `COVERAGE_REPORT=true rake` to generate also a nice HTML report.

There is a rake task for each test file: you can get the full list of all the test tasks (and the test files that each task runs)
with: `rake -D test_*`.

---

See also the [E2E Test Environment](https://github.com/ddnexus/pagy/tree/master/e2e).
