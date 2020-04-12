# frozen_string_literal: true

require 'capybara/minitest'
require 'webdrivers/chromedriver'

Capybara.register_driver :headless_chrome do |app|
  driver = Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      login_prefs: { browser: 'ALL' },
      chrome_options: {
        args: %w[headless disable-gpu window-size=1900,1200 lang=ja no-sandbox disable-dev-shm-usage],
      }
    )
  )
  driver
end

Capybara.server = :webrick
Capybara.javascript_driver = :headless_chrome
