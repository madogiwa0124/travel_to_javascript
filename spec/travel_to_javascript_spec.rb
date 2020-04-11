# frozen_string_literal: true

require 'test_app'
require 'time'
require 'js_console_dates'

RSpec.describe TravelToJavascript, type: :feature do
  include TravelToJavascript

  def call_js_get_date(session)
    session.execute_script('console.error(new Date())')
    session.execute_script('console.error(Date.now())')
  end

  let(:target_date) { DateTime.parse('2000-01-01 1:11:11.111+9:00') }
  let(:session) { Capybara::Session.new(:headless_chrome, TestApp) }

  it 'has a version number' do
    expect(TravelToJavascript::VERSION).not_to be nil
  end

  it 'locks time in javascript and restore time outside block.' do
    session.visit('/')
    call_js_get_date(session)
    travel_to_javascript(session, target_date) { call_js_get_date(session) }
    call_js_get_date(session)
    messages = session.driver.browser.manage.logs.get(:browser).collect(&:message)
    result = JsConsoleDates.new(messages).call
    expect(result[1]).to eq [target_date.to_s, target_date.to_s]
    expect(result[0]).to eq result[2]
  end
end
