# Ruby Test Environment

Ruby is tested with [`minitest`](https://github.com/minitest/minitest) through `rake` tasks. It also uses [`holdify`](https://github.com/ddnexus/holdify) as a snapshot system.

## Prerequisite

- Install the gems: `bundle install`
- E2e tests use Ferrum/Chrome. They expect to connect with Chrome at "http://127.0.0.1:9222". You should be able to run it locally with something like:
  ```
  # The bin name may be google-chrome-stable, chromium-browser, etc.
  google-chrome --headless=new \ 
                --remote-debugging-port=9222 \
                --no-first-run \
                --no-default-browser-check \
                --disable-gpu \
                --log-level=3
  ```

## Rake tasks

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

Run `rake default` (or just `rake`) to run also `rubocop`.
Set the `COVERAGE=true` env variable to run also `simplecov` code and branch coverage.

---

See also the [E2E Test Environment](https://github.com/ddnexus/pagy/tree/master/e2e).
