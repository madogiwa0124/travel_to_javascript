# frozen_string_literal: true

require 'test_app'
require 'time'

RSpec.describe TravelToJavascript, type: :feature do
  include TravelToJavascript
  class JsConsoleDates
    JS_NEW_DATE_REGXP = /[A-Z].+/.freeze
    JS_DATE_NOW_REGXP = /[0-9]{5,}.+/.freeze

    def initialize(messages)
      @messages = messages
    end

    def call
      js_parsed_console
    end

    private

    attr_reader :messages

    def js_parsed_console
      messages.select { |msg| msg.start_with?('console-api') }
              .map(&method(:match_data))
              .map(&method(:parsed_match_data))
              .map(&:to_s)
              .each_slice(2)
              .to_a
    end

    def match_data(msg)
      (msg.match(JS_NEW_DATE_REGXP) || msg.match(JS_DATE_NOW_REGXP))[0].to_s
    end

    def parsed_match_data(match_data)
      if match_data.match?(JS_NEW_DATE_REGXP)
        DateTime.parse(match_data)
      else
        Time.at(match_data.to_i / 1000).to_datetime
      end
    end
  end

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
