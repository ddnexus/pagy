# Pagy locales

## Please, submit your translation!

If you find that some translation could be improved, please, create an issue.

If you are using pagy with some language missing from the dictionary files, please, submit your translation!

You can create a Pull Request for your language, and get all the help you need to correctly complete it. Here is a check list.

### Check list for a new dictionary file:

- [ ] Find the pluralization rule for your language

  - [ ] Find the locale file you need in the [list of pluralization](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization) and check the pluralization rule in it. For example it is `::RailsI18n::Pluralization::OneOther.with_locale(:en)` for `en.rb`. Note the rule part i.e. `OneOther`. In pagy that translates to the symbol `:one_other`.

    - [ ] If the pluralization rule of your language is not the `:one_other` default, confirm that pagy already defines the pluralization rule of your dictionary file in the IRB console, with `require 'pagy'; p Pagy::I18n::P11n::RULE.keys`

      - [ ] If the rule is not defined, you can either: a) Add the rule as a new rule/lambda entry in the `Pagy::I18n::P11n::RULE` constant hash and relative tests or b) Just create an issue requesting the addition to the rule/lambda entry and tests.

      - [ ] Add an entry for your locale to the `Pagy::I18n::P11n::LOCALE` hash.

- [ ] add/edit the first line comment in the language rule in your dictionary file (e.g. `# :one_other pluralization ...`

- [ ] The mandatory pluralized entry in the dictionary file is the `item_name`. Please, provide all the plurals needed by your language. E.g. if your language uses the `:east_slavic` you should provide the plurals for `one`, `few`, `many` and `other`, if it uses `:one_other`, you should provide `one` and `other` plurals. If it uses `:other` you should only provide a single value. Look into other dictionary files to get some example. Ask if in doubt.

- [ ] The other entries in the dictionary file don't need any plural variant in most languages since the pluralization of the `item_name` in the sentence is enough. However, in some language, a whole sentence might need to be written in different ways for different counts. In that case you should add the different plurals for the sentence and the `count` will trigger the one that applies.

Feel free to ask for help in your Pull Request.

### Useful Links

- [Pagy I18n Documentation](https://ddnexus.github.io/pagy/api/frontend#i18n)
- [I18n Extra](https://ddnexus.github.io/pagy/extras/i18n)
