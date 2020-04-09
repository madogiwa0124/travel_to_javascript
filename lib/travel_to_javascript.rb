# frozen_string_literal: true

require 'travel_to_javascript/version'

module TravelToJavascript
  def travel_to_javascript(page, datetime)
    page.execute_script time_stop_javascript(datetime)
    yield
    page.execute_script time_undo_javsctipt
  end

  private

  def time_stop_javascript(rb_datetime)
    <<~JS
      originDate = Date;
      Date = #{time_stop_js_function_for_date(rb_datetime)};
      Date.now = #{time_stop_js_function_for_date_now(rb_datetime)};
    JS
  end

  def time_undo_javsctipt
    'Date = originDate;'
  end

  def time_stop_js_function_for_date(rb_datetime)
    <<~JS
      function (datetime) {
        if (datetime) {
          return new originDate(datetime);
        } else {
          return new originDate("#{rb_datetime.iso8601(6)}");
        }
      }
    JS
  end

  def time_stop_js_function_for_date_now(rb_datetime)
    <<~JS
      function (datetime) {
        if (datetime) {
          return new originDate(datetime).getTime();
        } else {
          return new originDate("#{rb_datetime.iso8601(6)}").getTime();
        }
      }
    JS
  end
end
