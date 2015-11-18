[![Build Status](https://travis-ci.org/wycleffsean/sowed.svg)](https://travis-ci.org/wycleffsean/sowed)
[![Code Climate](https://codeclimate.com/github/wycleffsean/sowed/badges/gpa.svg)](https://codeclimate.com/github/wycleffsean/sowed)
[![Test Coverage](https://codeclimate.com/github/wycleffsean/sowed/badges/coverage.svg)](https://codeclimate.com/github/wycleffsean/sowed/coverage)

# Sowed

Idempotent seeds for your ruby projects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sowed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sowed

## Usage

```ruby
Sow.ensure(Bar) do |fixed|
  fixed.name  'Cheers' # should never change
  street      '112 ½ Beacon Street'
  city        'Boston'
  bartender do |fixed|
    name 'Sam Malone'
  end
end

user = Sow.ensure(User, email: 'bryan.adams@gmail.ca')
# or
Sow.ensure(User) {|fixed| fixed.email 'bryan.adams@gmail.ca')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wycleffsean/sowed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

