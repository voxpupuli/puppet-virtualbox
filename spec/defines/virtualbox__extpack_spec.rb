require 'spec_helper'
require 'puppetlabs_spec_helper/rake_tasks'
require 'fileutils'

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
          checksum_string: 'd41d8cd98f00b204e9800998ecf8427e',
          archive_provider: provider
        }
      end

      shared_context 'archive fixtures' do
        before(:all) do # rubocop:disable RSpec/BeforeAfterAll
          FileUtils.rm_rf "#{fixture_path}/modules/archive"
        end

        before do
          mod = "#{fixture_path}/modules/archive"
          clone_repo('git', "https://github.com/#{provider}/puppet-archive", mod) unless File.directory? mod
        end
      end

      context 'with camptocamp/archive' do
        let(:provider) { 'camptocamp' }

        include_context 'archive fixtures'

        context 'with defaults' do
          let(:params) { sane_defaults }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum(true) }
          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_string('d41d8cd98f00b204e9800998ecf8427e') }
          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_type('md5') }
          it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
          it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').that_requires('Archive::Download[Oracle_VM_VirtualBox_Extension_Pack.tgz]') }
        end

        context 'with ensure => absent' do
          let(:params) { sane_defaults.merge(ensure: 'absent') }

          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_ensure('absent') }
          it { is_expected.to contain_file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack').with_ensure('absent') }
        end

        context 'with $verify_checksum => false' do
          let(:params) do
            sane_defaults.merge(verify_checksum: false,
                                checksum_type: 'sha1')
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum(false) }
          it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_string(nil) }
          it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
        end
      end

      context 'with voxpupuli/archive' do
        let(:provider) { 'voxpupuli' }

        include_context 'archive fixtures'

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
end
