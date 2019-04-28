# Pagy locales

### Please, submit your translation!

If you find that some translation could be improved, please, create an issue.

If you are using pagy with some language missing from the dictionary files, please, submit your translation!

You can create a Pull Request for your language, and get all the help you need to correctly complete it. Here is a check list.

### Check list for a new dictionary file:

- [ ] Find the pluralization rule for your language
    - find the locale file you need in the [list of pluralizations](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization) and check the pluralization rule in it. For example for `en.rb` it is`::RailsI18n::Pluralization::OneOther.with_locale(:en)`. Note the rule part i.e. `OneOther`. In pagy that translates to the symbol `:one_other`.

- [ ] add/edit the first line comment in the language rule in your dictionary file (e.g. `# :one_other pluralization ...`

- [ ] The mandatory pluralized entry in the dictionary file is the `item_name`. Please, provide all the plurals needed by your language. E.g. if your language uses the `:east_slavic` you should provide the plurals for `one`, `few`, `many` and `other`, if it uses `:one_other`, you should provide `one` and `other` plurals. If it uses `:other` you should only provide a single value. Look into other dictionary files to get some example. Ask if in doubt.

- [ ] The other entries in the dictionary file don't need any plural variant in most languages since the pluralization of the `item_name` in the sentence is enough. However, in some language, the whole sentence needs to be written in a different way for different plurals. In that case you should add the different plurals for the sentence and they will get triggered by the `count`.

Feel free to ask for help in your Pull Request.

### Useful Links

* [Pagy I18n Documentation](https://ddnexus.github.io/pagy/api/frontend#i18n)
* [I18n Extra](https://ddnexus.github.io/pagy/extras/i18n)

