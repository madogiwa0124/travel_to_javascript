# frozen_string_literal: true

require 'time'

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
