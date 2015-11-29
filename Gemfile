source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.2.0'
  gem 'puppet-lint'
  # https://github.com/rspec/rspec-core/issues/1864
  gem 'rspec', '< 3.2.0', {'platforms'=>['ruby_18']}
  gem 'rspec-puppet'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'pry'
end
