require 'spec_helper'

describe 'virtualbox::extpack' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
      let(:title) { 'Oracle_VM_VirtualBox_Extension_Pack' }
      let(:pre_condition) { 'include virtualbox' }
      let(:sane_defaults) do
        {
          ensure: 'present',
          source: 'http://server.example.com/extpack.vbox-extpack',
          checksum_string: 'd41d8cd98f00b204e9800998ecf8427e'
        }
      end

      context 'with defaults' do
        let(:params) { sane_defaults }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum('d41d8cd98f00b204e9800998ecf8427e') }
        it { is_expected.to contain_archive('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum_type('md5') }
        it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
        it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').that_requires('Archive[/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz]') }
      end

      context 'with ensure => absent' do
        let(:params) { sane_defaults.merge(ensure: 'absent') }

        it { is_expected.to contain_archive('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz').with_ensure('absent') }
        it { is_expected.to contain_file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack').with_ensure('absent') }
      end

      context 'with $verify_checksum => false' do
        let(:params) do
          sane_defaults.merge(verify_checksum: false,
                              checksum_type: 'sha1')
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum(nil) }
        it { is_expected.to contain_archive('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum_type(nil) }
        it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
      end
    end
  end
end
