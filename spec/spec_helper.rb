# frozen_string_literal: true

require 'bundler/setup'
require 'capybara/rspec'
require 'webdrivers/chromedriver'
require 'travel_to_javascript'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

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
