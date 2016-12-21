require 'spec_helper_acceptance'

describe 'virtualbox class' do
  package_name = case fact('osfamily')
                 when 'RedHat'
                   'VirtualBox-5.0'
                 else
                   'virtualbox-5.0'
                 end

  context 'default parameters' do
    it 'is idempotent' do
      pp = <<-EOS
      class { 'virtualbox': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe command('VBoxManage --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^5.0} }
    end

    describe command('/usr/lib/virtualbox/vboxdrv.sh status') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{VirtualBox kernel modules \(.*\) are loaded\.} }
    end
  end
end
