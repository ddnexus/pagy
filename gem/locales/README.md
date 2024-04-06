# Pagy locales

## Please, submit your translation!

If you find that some translation could be improved, please, create an issue.

If you are using pagy with some language missing from the dictionary files, please, submit your translation!

You can create a Pull Request for your language, and get all the help you need to correctly complete it. Here is a check list.

### Check list for a new dictionary file:

- [ ] Find the pluralization rule for your language (see below for details on how to do this).

  - [ ] Find the locale file you need in
    the [list of pluralization](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization) and check the
    pluralization rule in it. For example it is `::RailsI18n::Pluralization::OneOther.with_locale(:en)`
    for [`en.rb`](https://github.com/svenfuchs/rails-i18n/blob/master/rails/pluralization/en.rb). Note the rule part
    i.e. `OneOther`. In pagy that translates to the symbol `:one_other`.

    - [ ] If the pluralization rule of your language is not the `:one_other` default, confirm that pagy already defines the
      pluralization rule of your dictionary file in the IRB console, with `require 'pagy'; p Pagy::I18n::P11n::RULE.keys` or check
      for it directly in the [i18n.rb file](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb#L26-L91).

      - [ ] If the rule is not defined, you can either: a) Add the rule as a new rule/lambda entry in the `Pagy::I18n::P11n::RULE`
        constant hash and relative tests or b) Just create an issue requesting the addition to the rule/lambda entry and tests.

      - [ ] Add an entry for your locale to
        the [`Pagy::I18n::P11n::LOCALE` hash](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb#L95C1-L115).

- [ ] add/edit the first line comment in the language rule in your dictionary file (e.g. `# :one_other pluralization ...`. For
  example, the [Japanese locale file](https://github.com/ddnexus/pagy/blob/master/gem/lib/locales/ja.yml#L1) uses
  the: `# :other pluralization ...`

- [ ] The mandatory pluralized entry in the dictionary file are the `aria_label.nav` and the `item_name`. Please, provide all the
  plurals needed by your language. E.g. if your language uses the `:east_slavic` you should provide the plurals
  for `one`, `few`, `many` and `other`, if it uses `:one_other`, you should provide `one` and `other` plurals. If it uses `:other`
  you should only provide a single value. Look into other dictionary files to get some example. Ask if in doubt.

Feel free to ask for help in your Pull Request.

### Useful Links

- [Pagy I18n Documentation](https://ddnexus.github.io/pagy/docs/api/i18n)
- [I18n Extra](https://ddnexus.github.io/pagy/docs/extras/i18n/)
