
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "paypal-sdk/subscriptions/version"

Gem::Specification.new do |spec|
  spec.name          = "paypal-sdk-subscriptions"
  spec.version       = PayPal::SDK::Subscriptions::VERSION
  spec.authors       = ["Piers Chambers"]
  spec.email         = ["piers@varyonic.com"]

  spec.summary       = %q{Missing PayPal REST SDK for Subscriptions Management.}
  spec.homepage      = "https://github.com/varyonic/paypal-subscriptions-sdk-ruby"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'paypal-sdk-rest-pmrb'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
