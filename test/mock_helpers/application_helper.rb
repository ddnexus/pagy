module ApplicationHelper
  include Pagy::Frontend

  def any_method_name()
    I18n.t("test")
  end

end