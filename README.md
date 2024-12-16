# PayPal REST SDK for Subscriptions Management

[![Version         ][rubygems_badge]][rubygems]
[![Github Actions  ][actions_badge]][actions]

Missing PayPal REST SDK for [Subscriptions Management][subscriptions_full_integration] as [released April 2019][release_notes].

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
  client_id: <%= ENV.fetch('client_id') %>
  client_secret: <%= ENV.fetch('client_secret') %>
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
  :client_id => ENV.fetch('client_id'),
  :client_secret => ENV.fetch('client_secret'),
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

The test suite runs transactions against the PayPal sandbox, creating products and plans that it cannot delete.  Initial tests may fail until at least one product and plan has been created.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/varyonic/paypal-sdk-subscriptions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[rubygems_badge]: http://img.shields.io/gem/v/paypal-sdk-subscriptions.svg
[rubygems]: https://rubygems.org/gems/paypal-sdk-subscriptions
[actions_badge]: https://github.com/paypal-merchants-rb/paypal-subscriptions-sdk-ruby/workflows/ci/badge.svg
[actions]: https://github.com/paypal-merchants-rb/paypal-subscriptions-sdk-ruby/actions

[release_notes]: https://developer.paypal.com/docs/release-notes/release-notes-2019/#april
[subscriptions_full_integration]: https://developer.paypal.com/docs/subscriptions/full-integration/subscription-management/