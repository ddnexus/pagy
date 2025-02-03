# Pagy locales

## Please, submit your translation!

If you find that some translation could be improved, please, create an issue.

If you are using pagy with some language missing from the dictionary files, please, submit your translation!

You can create a Pull Request for your language, and get all the help you need to correctly complete it. Here is a checklist.

### Checklist for a new dictionary file:

- [ ] Find the pluralization rule for your language (see below for details on how to do this).

  - [ ] Find the locale file you need in
    the [list of pluralization](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization) and check the
    pluralization rule required in it. For example the name of the file required is `one_other`
    for [`en.rb`](https://github.com/svenfuchs/rails-i18n/blob/master/rails/pluralization/en.rb). In pagy that translates to `'OneOther'`. If you cannot find the pluralization in the aforementioned link, see if you can find it [in the unicode pluralization rules](https://www.unicode.org/cldr/charts/45/supplemental/language_plural_rules.html).

    - [ ] Confirm that pagy already defines the
      pluralization rule of your dictionary file by checking the file in the [P18n dir](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n/p18n).

      - [ ] If the rule is not defined, you can either: a) Add a new module for the pluralization (practically adapting the same pluralization from the corresponding rails-i18n file) and add some tests for it; or b) Just create an issue requesting the addition to the pluralization entry and tests.

- [ ] Duplicate another pagy locale dictionary file and translate it to your language.

  - [ ] Check that the `p11n` entry point to a module in the P18n dir 

- [ ] The mandatory pluralized entry in the dictionary file are the `aria_label.nav` and the `item_name`. Please, provide all the
  plurals needed by your language. E.g. if your language uses the `EastSlavic` you should provide the plurals
  for `one`, `few`, `many` and `other`, if it uses `OneOther`, you should provide `one` and `other` plurals. If it uses `Other`
  you should only provide a single value. Look into other dictionary files to get some example. Ask if in doubt.

Feel free to ask for help in your Pull Request.

### Useful Links

- [Pagy I18n Documentation](https://ddnexus.github.io/pagy/docs/api/i18n)
- [I18n Extra](https://ddnexus.github.io/pagy/docs/extras/i18n/)
