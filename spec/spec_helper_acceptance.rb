require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker

shared_examples 'an idempotent puppet code' do
  it 'applies without error' do
    apply_manifest(pp, catch_failures: true)
  end
  it 'applies idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
end
