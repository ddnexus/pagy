# frozen_string_literal: true

class Pagy
  module I18n
    module P11n
      autoload :Arabic,          PAGY_PATH.join('support/i18n/p11n/arabic')
      autoload :EastSlavic,      PAGY_PATH.join('support/i18n/p11n/east_slavic')
      autoload :OneOther,        PAGY_PATH.join('support/i18n/p11n/one_other')
      autoload :OneUptoTwoOther, PAGY_PATH.join('support/i18n/p11n/one_upto_two_other')
      autoload :Other,           PAGY_PATH.join('support/i18n/p11n/other')
      autoload :Polish,          PAGY_PATH.join('support/i18n/p11n/polish')
      autoload :WestSlavic,      PAGY_PATH.join('support/i18n/p11n/west_slavic')
    end
  end
end
