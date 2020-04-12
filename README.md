# TravelToJavascript

This gem provides a helper `travel_to_javascript` that locks time in javascript.
It supports `rspec` and `minitest` using capybara.

Override `Date` and `Date.now` in JavaScript by args.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'travel_to_javascript'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install travel_to_javascript

## Usage

`travel_to_javascript` can be used by include `TravelToJavascript`.

By passing the object of `Capybara::Session`(ex. `page`) and the date and time to the argument of `travel_to_javascript`, the time of JavaScript in the block can be fixed at the time of the argument.

### Rspec

``` ruby
require 'spec_helper'
require 'travel_to_javascript'

RSpec.describe 'SampleFeatureSpec', type: :feature do
  include TravelToJavascript

  it 'sample spec' do
   # NOTE: Use a JavaScript enabled driver.
    page = Capybara::Session.new(:headless_chrome, TestApp)
    travel_to_javascript(page, DateTime.parse('2000-01-01 1:11:11.111+9:00')) do
      page.execute_script('console.error(Date.now(), new Date())')
      pp page.driver.browser.manage.logs.get(:browser).map(&:message)
      # locks time by args in block.
      # => ["console-api 2:32 946656671111 Sat Jan 01 2000 01:11:11 GMT+0900"]
    end
    page.execute_script('console.error(Date.now(), new Date())')
    pp page.driver.browser.manage.logs.get(:browser).map(&:message)
    # restore time outside block.
    # => ["console-api 2:32 1586652460142 Sun Apr 12 2020 09:47:40 GMT+0900"]
  end
end
```

### Minitest

``` ruby
require 'test_helper'
require 'travel_to_javascript'

class SampleFeatureTest < Minitest::Test
  include TravelToJavascript

  def test_sample
     # NOTE: Use a JavaScript enabled driver.
    page = Capybara::Session.new(:headless_chrome, TestApp)
    travel_to_javascript(page, DateTime.parse('2000-01-01 1:11:11.111+9:00')) do
      page.execute_script('console.error(Date.now(), new Date())')
      pp page.driver.browser.manage.logs.get(:browser).map(&:message)
      # locks time by args in block.
      # => ["console-api 2:32 946656671111 Sat Jan 01 2000 01:11:11 GMT+0900"]
    end
    page.execute_script('console.error(Date.now(), new Date())')
    pp page.driver.browser.manage.logs.get(:browser).map(&:message)
    # restore time outside block.
    # => ["console-api 2:32 1586652460142 Sun Apr 12 2020 09:47:40 GMT+0900"]
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Madogiwa0124/travel_to_javascript. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Madogiwa0124/travel_to_javascript/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TravelToJavascript project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Madogiwa0124/travel_to_javascript/blob/master/CODE_OF_CONDUCT.md).
