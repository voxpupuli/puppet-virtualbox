require 'spec_helper_acceptance'

describe 'virtualbox extpack' do
  let(:install) do
    <<-EOS
    include virtualbox

    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure          => present,
      source          => 'http://download.virtualbox.org/virtualbox/6.0.0_RC1/Oracle_VM_VirtualBox_Extension_Pack-6.0.0_RC1.vbox-extpack',
      checksum_string => 'deecf9b15ffda29d4d5da4349763fd11',
    }
    EOS
  end

  let(:uninstall) do
    <<-EOS
    include virtualbox

    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure          => absent,
      source          => 'http://download.virtualbox.org/virtualbox/6.0.0_RC1/Oracle_VM_VirtualBox_Extension_Pack-6.0.0_RC1.vbox-extpack',
      checksum_string => 'deecf9b15ffda29d4d5da4349763fd11',
    }
    EOS
  end

  context 'install extpack' do
    it 'is idempotent' do
      apply_manifest(install, catch_failures: true)
      apply_manifest(install, catch_changes: true)
    end

    describe file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') do
      it { is_expected.to be_directory }
    end

    describe file('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz') do
      it { is_expected.to be_file }
      its(:md5sum) { is_expected.to eq 'deecf9b15ffda29d4d5da4349763fd11' }
    end

    describe command('VBoxManage list extpacks') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{Extension Packs: 1} }
    end
  end

  context 'uninstall extpack' do
    it 'is idempotent' do
      apply_manifest(install, catch_failures: true)
      apply_manifest(uninstall, catch_failures: true)
      apply_manifest(uninstall, catch_changes: true)
    end

    describe file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') do
      it { is_expected.not_to be_directory }
    end

    describe file('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz') do
      it { is_expected.not_to be_file }
    end

    describe command('VBoxManage list extpacks') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{Extension Packs: 0} }
    end
  end
end
