# frozen_string_literal: true

module NavTests
  def nav_check(method, pagy)  # e.g. pagy_bootstrap_nav
    _(app.send(method, pagy)).must_rematch :plain
    _(app.send(method, pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch :extras
  end

  def nav_js_check(method, pagy)  # e.g. pagy_bootstrap_nav_js
    _(app.send(method, pagy)).must_rematch :plain
    _(app.send(method, pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                      steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
  end

  def combo_nav_js_check(method, pagy)  # e.g. pagy_bootstrap_combo_nav_js
    _(app.send(method, pagy)).must_rematch :plain
    _(app.send(method, pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch :extras
  end
end
