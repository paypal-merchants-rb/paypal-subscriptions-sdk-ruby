# PayPal REST SDK for Subscriptions Management

Missing PayPal REST SDK for [Subscriptions Management][subscriptions_full_integration] [released April 2019][release_notes].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paypal-sdk-subscriptions'
```

And then execute:

    $ bundle

## Configuration

Create a configuration file(`config/paypal.yml`):

```yaml
development: &default
  mode: sandbox
  client_id: EBWKjlELKMYqRNQ6sYvFo64FtaRLRR5BdHEESmha49TM
  client_secret: EO422dn3gQLgDbuwqTjzrFgFtaRLRR5BdHEESmha49TM
test:
  <<: *default
production:
  mode: live
  client_id: CLIENT_ID
  client_secret: CLIENT_SECRET
```

Load Configurations from specified file:

```ruby
PayPal::SDK::Core::Config.load('spec/config/paypal.yml',  ENV['RACK_ENV'] || 'development')
```

Without configuration file:

```ruby
PayPal::SDK.configure(
  :mode => "sandbox", # "sandbox" or "live"
  :client_id => "EBWKjlELKMYqRNQ6sYvFo64FtaRLRR5BdHEESmha49TM",
  :client_secret => "EO422dn3gQLgDbuwqTjzrFgFtaRLRR5BdHEESmha49TM",
  :ssl_options => { } )
```

Logger configuration:

```ruby
PayPal::SDK.logger = Logger.new(STDERR)

# change log level to INFO
PayPal::SDK.logger.level = Logger::INFO
```
**NOTE**: At `DEBUG` level, all requests/responses are logged except when `mode` is set to `live`. In order to disable request/response printing, set the log level to `INFO` or less verbose ones.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paypal-sdk-subscriptions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[release_notes]: https://developer.paypal.com/docs/release-notes/release-notes-2019/#april
[subscriptions_full_integration]: https://developer.paypal.com/docs/subscriptions/full-integration/subscription-management/