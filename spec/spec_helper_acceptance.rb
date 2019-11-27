require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module
install_module_dependencies

shared_examples 'an idempotent puppet code' do
  it 'applies without error' do
    apply_manifest(pp, catch_failures: true)
  end
  it 'applies idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
end
