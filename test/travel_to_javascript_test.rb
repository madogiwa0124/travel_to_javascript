# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../spec/test_app'
require_relative '../spec/js_console_dates'
require 'time'

class TravelToJavascriptTest < Minitest::Test
  include TravelToJavascript

  def call_js_get_date(session)
    session.execute_script('console.error(new Date())')
    session.execute_script('console.error(Date.now())')
  end

  def js_console_dates(session)
    JsConsoleDates.new(
      session.driver.browser.manage.logs.get(:browser).collect(&:message)
    ).call
  end

  def test_has_a_version_number
    assert !TravelToJavascript::VERSION.nil?
  end

  def test_locks_time_in_js_and_restore_time_outside_block
    target_date = DateTime.parse('2000-01-01 1:11:11.111+9:00')
    session = Capybara::Session.new(:headless_chrome, TestApp)
    session.visit('/')
    call_js_get_date(session)
    travel_to_javascript(session, target_date) { call_js_get_date(session) }
    call_js_get_date(session)
    results = js_console_dates(session)
    assert_equal results[1], [target_date.to_s, target_date.to_s]
    # TODO: The first JavaScript execution and the third JavaScript
    # execution will fail if there is an interval exceeding 1 second.
    assert_equal results[0], results[2]
  end
end
