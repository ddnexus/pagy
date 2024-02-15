# Ruby Test Environment

Ruby is tested with `minitest` through `rake` tasks.

## Run the Ruby tests

Almost every test recreates a different environment and must run in a separate process in order to avoid to override other tests. That means that you can run a single test file (or a single spec in a test file) and it will be OK, but you cannot run a directory of test file, with a single minitest command because they will interfere with each other and will fail.

### Rake tasks

If you want to run all code tests use the `:test` task. For the full suite (including rubocop coverage and other checks), you can just run `rake default` (or just `rake`), or `COVERAGE_REPORT=true rake` to generate also a nice HTML report.

There is a rake task for each test file: you can get the full list of of all the test tasks (and test files that each task run) with: `rake -D test_*`.

See also the [E2E Test Environment](https://github.com/ddnexus/pagy/tree/master/e2e).
