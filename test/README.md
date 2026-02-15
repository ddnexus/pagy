# Ruby Test Environment

Ruby is tested with [`minitest`](https://github.com/minitest/minitest) through `rake` tasks. It also uses [`holdify`](https://github.com/ddnexus/holdify) as a snapshot system.

## Prerequisite

- Install the gems: `bundle install`
- E2e tests use Ferrum/Chrome. They expect to connect with Chrome at "http://127.0.0.1:9222". We use a container in a pod with the pagy-ruby-dev container in it, however you should be able to run it also locally with something like:
  ```
  # The bin name may be google-chrome-stable, chromium-browser, etc.
  google-chrome --headless  \
                --disable-gpu \
                --remote-debugging-port=9222 \
                --no-first-run \
                --no-default-browser-check \
                --user-data-dir=remote-profile
  ```

### Rake tasks

```
rake test
rake test:e2e
rake test:e2e:calendar
rake test:e2e:demo
rake test:e2e:keynav
rake test:e2e:rails
rake test:e2e:repro
rake test:unit
```

Run `rake default` (or just `rake`) to run also rubocp.
Set the `COVERAGE=true` env variable to run also simplecov code and branch coverage.

---

See also the [E2E Test Environment](https://github.com/ddnexus/pagy/tree/master/e2e).
