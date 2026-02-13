# frozen_string_literal: true

require 'nokogiri'
require 'json'
require 'pagy/modules/b64'

module E2eFunctions
  LOCATION_RE = %r{\Ahttp://#{Regexp.escape(E2eApp::IP)}:808\d/}

  def check_nav(selector, path: '/', pages: %w[3 50], rjs: false)
    browser.goto(path)

    if rjs
      [600, 700].each do |width|
        browser.resize(width: width, height: 1000)
        browser.reload
        browser.wait_for_reload(timeout)

        perform_check_nav(selector, pages)
      end
      browser.resize(width: 1024, height: 768)
    else
      perform_check_nav(selector, pages)
    end
  end

  def check_combo_nav(selector, path: '/')
    input_selector = "#{selector} input"

    browser.goto(path)
    hold_location
    hold_html(selector)

    # Check Next
    browser.at_css(selector).at_xpath(".//a[contains(text(), '>')]")&.click
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)

    # Test valid entry
    # Re-finding node after potential navigation/reload
    browser.at_css(input_selector).focus.type("3", :enter) # --> navigate to page 3
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)

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
    input = browser.at_css(input_selector)
    input.focus.type("50")
    input.blur # --> navigate to page 50
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)

    # Test arrow keys
    browser.at_css(input_selector).focus.type(:down, :enter)
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)

    # Check Previous
    browser.at_css(selector).at_xpath(".//a[contains(text(), '<')]")&.click
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)
  end

  def check_info(selector, path: '/')
    [1, 36, 50].each do |page|
      goto_query(path, "?page=#{page}")
      hold_location
      hold_html(selector)
    end
  end

  def check_limit_selector(selector, path: '/')
    input_selector = "#{selector} input"
    [1, 36, 50].each do |page|
      goto_query(path, "?page=#{page}")
      hold_location
      hold_html(selector)
      current_url = browser.current_url

      if page == 36
        arr = %w[abcd 1000]
        arr.each do |invalid|
          input = browser.at_css(input_selector)
          input.focus.type(invalid, :enter)
          browser.wait_for_reload(timeout)

          refute_equal invalid, input.value
          assert_match(/page=#{page}/, current_url)
        end
      end

      browser.at_css(input_selector).focus.type("10", :enter)
      browser.wait_for_reload(timeout)
      hold_location
      hold_html(selector)

      browser.at_css(input_selector).focus.type("17")
      browser.at_css(input_selector).blur
      browser.wait_for_reload(timeout)
      hold_location
      hold_html(selector)

      browser.at_css(input_selector).focus.type(:up, :enter)
      browser.wait_for_reload(timeout)
      hold_location
      hold_html(selector)

      goto_query(path, '?page=2&limit=10')
      assert_match(/page=2/, browser.current_url)

      browser.at_css(input_selector).focus.type("5", :enter)
      browser.wait_for_reload(timeout)
      hold_location
      assert_match(/page=3/, browser.current_url)
    end
  end

  private

  def timeout = 0.2

  def goto_query(path, query)
    browser.goto("#{browser.base_url}#{path}#{query}")
  end

  def location
    location = browser.current_url.sub(LOCATION_RE, '')

    return location unless %i[keyset keynav].include?(app_id) &&
                           (match = location.match(/[?&]page=([^&]+)/))

    begin
      decoded = Pagy::B64.urlsafe_decode(match[1])
      if app_id == :keynav
        args = JSON.parse(decoded)
        if args.is_a?(Array)
          args.shift(2)
          decoded = args.inspect
        end
      end
      location[match.begin(1)...match.end(1)] = decoded
    rescue StandardError
      # Ignore
    end
    location
  end

  def valid_html
    # Nokogiri::HTML5 uses the Gumbo parser (standard-compliant)
    doc = Nokogiri::HTML5.parse(browser.body)
    errors = doc.errors

    message = "HTML5 Validation failed at #{browser.current_url}:\n"
    message << errors.map { |e| "[Line #{e.line}, Col #{e.column}] #{e.message}" }.join("\n")

    assert_empty errors, message
  end

  def hold_location
    expect({ location: }).to_hold

    # Ensure the content of the location is valid
    valid_html
  end

  def hold_html(*selectors)
    # Hold records
    if (records = browser.at_css('#records'))
      expect({ '#records' => records.inner_text }).to_hold
    end

    # Hold content for each selector
    selectors.each do |selector|
      element = browser.at_css(selector)
      next unless element

      html = element.property('outerHTML')
      # Remove data-pagy and href attributes to avoid flakiness
      # We use simple regex because we control the output and it's faster/simpler than parsing
      html.gsub!(/ data-pagy="[^"]*"/, '')
      html.gsub!(/ href="[^"]*"/, '')

      expect({ selector => html }).to_hold
    end
  end

  def perform_check_nav(selector, pages)
    hold_html(selector)

    # Check Next
    browser.at_css(selector).at_xpath(".//a[contains(text(), '>')]")&.click
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)

    # Check specific pages
    pages.each do |page|
      browser.at_css(selector).at_xpath(".//a[contains(text(), '#{page}')]")&.click
      browser.wait_for_reload(timeout)
      hold_location
      hold_html(selector)
    end

    # Check Previous
    browser.at_css(selector).at_xpath(".//a[contains(text(), '<')]")&.click
    browser.wait_for_reload(timeout)
    hold_location
    hold_html(selector)
  end
end
