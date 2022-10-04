# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  on host, puppet('module', 'install', 'puppet-archive')
end

shared_examples 'an idempotent puppet code' do
  it 'applies without error' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
end
