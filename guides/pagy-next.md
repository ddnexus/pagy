#

## :icon-zap:&nbsp;&nbsp;Pagy NEXT

---

!!!tip You can use the NEXT version NOW!

Just edit the Gemfile...

```diff Gemfile (diff)
- gem 'pagy', '~> 43.5'                         # MINOR version restriction
+ gem 'pagy', '~> 43.5.2', require: 'pagy/next' # PATCH version restriction + pagy/next entry point
```

As an alternative _(without Gemfile changes)_, ensure the environment variable `PAGY_NEXT=true` is set, BEFORE `pagy` is required.

```rb IRB
$ PAGY_NEXT=true irb
>> require 'pagy'
=> true
>> Pagy::VERSION
=> "43.5.2.next"
```
!!!

### How does it work?

Pagy NEXT is the code that will be released as the next MAJOR version. It is already implemented and available in the current version, however it is overridden with the legacy code and deprecation warnings to respect the [SemVer](https://semver.org/) contract.

Pagy NEXT provides an opt-in mechanism to bypass the legacy layer entirely. By using `require: 'pagy/next'` or setting `PAGY_NEXT=true`, you effectively run the next MAJOR version's code today.

### How should you maintain it?

This "early access" mode is lighter and faster, but **requires immediate adherence to the latest API changes**.

!!!warning Adjust the gem update policy!

- Use a stricter PATCH version restriction (e.g., replace `~> 43.5` with `~> 43.5.2`)
- Follow the [Deprecations Instructions](/changelog/#deprecations) after `bundle update` involving MINOR or MAJOR releases.
!!!

With the PATCH version restriction, bundle will automatically update **only** PATCH releases, ensuring your NEXT code won't break on update. However, remember to manually check `bundle outdated` more often to avoid missing MINOR or MAJOR releases.
