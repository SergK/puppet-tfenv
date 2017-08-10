if ENV['TRAVIS'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end
RSpec.configure(&:raise_errors_for_deprecations!)

require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/fixtures'
  add_filter '/vendor/'
end

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.environmentpath = File.join(Dir.pwd, 'spec')
  c.tty = true

  c.after(:suite) do
    exit(1) if RSpec::Puppet::Coverage.report!(100)
  end
end
