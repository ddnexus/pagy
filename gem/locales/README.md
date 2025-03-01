---
layout: page
visibility: hidden
---

# Pagy locales

## Please, submit your translation!

If you find that a translation could be improved, please create an issue.

If you are using Pagy with a language missing from the dictionary files, please submit your translation!

You can create a Pull Request for your language and get all the help you need to complete it correctly. Here is a checklist:

### Checklist for a new dictionary file:

#### 1. Find the pluralization rules for your language

- Locate the locale file you need in
  the [list of pluralizations](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization)
- Check the pluralization rules required in it. For example, the name of the file required is `one_other`
  for [`en.rb`](https://github.com/svenfuchs/rails-i18n/blob/master/rails/pluralization/en.rb). In Pagy, that translates to
  `'OneOther'`.
  - If you cannot find the pluralization in the link above, check
    the [Unicode pluralization rules](https://www.unicode.org/cldr/charts/45/supplemental/language_plural_rules.html).
- Confirm that pagy already defines the pluralization rules of your dictionary file by checking the file in
  the [P18n directory](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/modules/i18n/p18n).
  - If the rules are not defined, you can either:
    - Add a new module for the pluralization (by adapting the same pluralization from the corresponding rails-i18n file) and
      include tests for it;
    - Or, create an issue requesting the addition of the pluralization entry and its tests.

#### 2. Duplicate an existing Pagy locale dictionary file and translate it into your language.

- Check that the `p11n` entry points to a module in
  the [P18n directory](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/modules/i18n/p18n).
- The mandatory pluralized entries in the dictionary file are `aria_label.nav` and `item_name`. Please provide all the necessary
  plurals for your language. For example, if your language uses the `EastSlavic` rule, you should provide the plurals for `one`,
  `few`, `many`, and `other`. If it uses
  `Other`, you should only provide a single value. Check other dictionary files for examples, and ask if you have any doubts.

Feel free to ask for help in your Pull Request.

### Useful Links

- [Pagy I18n Documentation](https://ddnexus.github.io/pagy/resources/i18n)
