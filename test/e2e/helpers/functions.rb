# frozen_string_literal: true

require 'nokogiri'
require 'json'
require 'pagy/modules/b64'

module E2eFunctions
  LOCATION_RE = %r{\Ahttp://#{Regexp.escape(E2eApp::IP)}:808\d/?}

  # Injected into each new document: it identifies the document and tracks its load, DOM changes and unload
  PAGE_TRACKER = <<~JS
    (() => {
      const e2e = window.__e2e = { id: Math.random().toString(36).slice(2), loaded: false, changed: performance.now() };
      // Registered before the page listeners, so the timeout runs after all of them (e.g. Pagy.init)
      addEventListener('load', () => setTimeout(() => { e2e.loaded = true; e2e.changed = performance.now() }));
      // Fired synchronously at the start of a navigation, i.e. before the click/type/blur command returns
      addEventListener('beforeunload', () => { e2e.leaving = true });
      new MutationObserver(() => { e2e.changed = performance.now() })
        .observe(document, { subtree: true, childList: true, attributes: true, characterData: true });
    })();
  JS
  SETTLE_MS    = 200 # without DOM changes after load (e.g. series_nav_js rendering, keynav augmentation)
  PAGE_TIMEOUT = 15

  # Run the action, then wait for the page to be loaded and settled.
  # If the action started a navigation, wait for the new document: the old one doesn't count.
  def settle
    from = page_id
    yield
    from = nil unless navigating?(from)
    deadline = Time.now + PAGE_TIMEOUT
    until page_settled?(from)
      flunk "Timeout waiting for the page to settle at #{browser.current_url}" if Time.now > deadline

      sleep 0.05
    end
  end

  def page_id = browser.evaluate('window.__e2e?.id')

  def navigating?(from)
    browser.evaluate('window.__e2e?.id !== arguments[0] || !!window.__e2e?.leaving', from)
  rescue Ferrum::Error # the old document is already gone
    true
  end

  def page_settled?(from)
    id, loaded, quiet = browser.evaluate('window.__e2e && [__e2e.id, __e2e.loaded, performance.now() - __e2e.changed]')
    id != from && loaded && quiet >= SETTLE_MS
  rescue Ferrum::Error # evaluated while navigating
    false
  end

  def visit(url) = settle { browser.goto(url) }

  def goto_and_hold(id, path: '/', query: '')
    visit("#{path}#{query}")
    hold_location
    hold_html(id)
  end

  def interact_and_hold(*ids, &)
    settle(&)
    hold_location
    hold_html(*ids)
  end

  # Click the first link in id containing text (if any), and hold
  def click_and_hold(id, text)
    interact_and_hold(id) { browser.at_css(id).at_xpath(".//a[contains(text(), '#{text}')]")&.click }
  end

  def hold_location
    expect({ location: }).to_hold

    # Ensure the content of the location is valid
    validate_html
  end

  def location
    loc = browser.current_url.sub(LOCATION_RE, '')

    return loc unless %i[keyset keynav].include?(app_id) &&
                      (match = loc.match(/[?&]page=([^&]+)/))

    begin
      decoded = Pagy::B64.urlsafe_decode(match[1])
      if app_id == :keynav
        args = JSON.parse(decoded)
        if args.is_a?(Array)
          args.shift(2)
          decoded = args.inspect
        end
      end
      loc[match.begin(1)...match.end(1)] = decoded
    rescue StandardError
      # Ignore
    end
    loc
  end

  def validate_html
    # Nokogiri::HTML5 uses the Gumbo parser (standard-compliant)
    doc = Nokogiri::HTML5.parse(browser.body)
    errors = doc.errors

    message = "HTML5 Validation failed at #{browser.current_url}:\n"
    message << errors.map { |e| "[Line #{e.line}, Col #{e.column}] #{e.message}" }.join("\n")

    assert_empty errors, message
  end

  def hold_html(*ids)
    # Hold records
    if (records = browser.at_css('#records'))
      expect({ '#records' => records.inner_text }).to_hold
    end

    # Hold content for each id
    ids.each do |id|
      element = browser.at_css(id)
      refute_nil element, "Element #{id} not found at #{browser.current_url}"

      html = element.property('outerHTML')
      # Remove data-pagy and href attributes to avoid flakiness
      # We use simple regex because we control the output, and it's faster/simpler than parsing
      html.gsub!(/ data-pagy="[^"]*"/, '')
      html.gsub!(/ href="[^"]*"/, '')

      expect({ id => html }).to_hold
    end
  end

  def check_nav(id, pages: %w[3 50], rjs: false, **)
    goto_and_hold(id, **)

    if rjs
      [600, 700].each do |width|
        browser.resize(width: width, height: 1000)
        settle { browser.reload }

        interact_with_nav(id, pages)
      end
      browser.resize(width: 1024, height: 768)
    else
      interact_with_nav(id, pages)
    end
  end

  def interact_with_nav(id, pages)
    click_and_hold(id, '>')                          # Check Next
    pages.each { |page| click_and_hold(id, page) }   # Check specific pages (not all present in any page)
    click_and_hold(id, '<')                          # Check Previous
  end

  def check_input_nav(id, path: '/')
    input_selector = "#{id} input"

    goto_and_hold(id, path:)
    click_and_hold(id, '>') # Check Next

    # Test valid entry
    # Re-finding node after potential navigation/reload
    interact_and_hold(id) do
      browser.at_css(input_selector).focus.type("3", :enter) # --> navigate to page 3
    end

    # Test invalid entry
    %w[abcd 1000].each do |invalid|
      current_input = browser.at_css(input_selector)
      current_input.focus.type(invalid, :enter)

      # If 'abcd' was ignored by the browser, value won't change and it remains valid.
      # If '1000' was entered but exceeds max, validity.valid will be false.
      is_valid = current_input.evaluate("this.checkValidity()")

      # We assert it's invalid OR that the browser blocked the input (value didn't change to the invalid string)
      assert (!is_valid || current_input.value != invalid), "Browser should have rejected or ignored '#{invalid}'"
      assert_match(/page=3/, browser.current_url)
    end

    # Test blur (re-finding again)
    interact_and_hold(id) do
      input = browser.at_css(input_selector)
      input.focus.type("50")
      input.blur # --> navigate to page 50
    end

    # Test arrow keys
    interact_and_hold(id) do
      browser.at_css(input_selector).focus.type(:down, :enter)
    end

    click_and_hold(id, '<') # Check Previous
  end

  def check_info(id, **)
    [1, 36, 50].each do |page|
      goto_and_hold(id, **, query: "?page=#{page}")
    end
  end

  def check_limit_tag(id, path: '/')
    input_selector = "#{id} input"
    [1, 36, 50].each do |page|
      goto_and_hold(id, path:, query: "?page=#{page}")

      if page == 36
        arr = %w[abcd 1000]
        arr.each do |invalid|
          input = browser.at_css(input_selector)
          input.focus.type(invalid, :enter)

          refute_equal invalid, input.value
          assert_match(/page=#{page}/, browser.current_url)
        end
      end
      interact_and_hold(id) do
        browser.at_css(input_selector).focus.type("10", :enter)
      end

      interact_and_hold(id) do
        browser.at_css(input_selector).focus.type("17").blur
      end

      interact_and_hold(id) do
        browser.at_css(input_selector).focus.type(:up, :enter)
      end

      visit("#{path}?page=2&limit=10")
      assert_match(/page=2/, browser.current_url)

      interact_and_hold(id) do
        browser.at_css(input_selector).focus.type("5", :enter)
      end
      assert_match(/page=3/, browser.current_url)
    end
  end
end
