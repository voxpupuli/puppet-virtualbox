require 'spec_helper'

describe 'virtualbox::extpack' do
  let(:title) { 'Oracle_VM_VirtualBox_Extension_Pack' }
  let(:pre_condition) { 'include virtualbox' }
  let(:facts) {{
    :osfamily => 'RedHat',
    :operatingsystem => "RedHat",
    :operatingsystemrelease => '6.5',
    :path => '/sbin:/bin',
  }}

  sane_defaults = {
    :ensure           => 'present',
    :source           => 'http://server.example.com/extpack.vbox-extpack',
    :checksum_string  => 'd41d8cd98f00b204e9800998ecf8427e',
  }

  context 'with defaults' do
    let(:params) {sane_defaults}

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum(true) }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_string('d41d8cd98f00b204e9800998ecf8427e') }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_type('md5') }
    it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
    it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').that_requires('Archive::Download[Oracle_VM_VirtualBox_Extension_Pack.tgz]') }

  end

  context 'with ensure => absent' do
    let(:params) {sane_defaults.merge({:ensure => 'absent'})}
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_ensure('absent') }
    it { is_expected.to contain_file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack').with_ensure('absent') }
  end

  context 'with $verify_checksum => false' do
    let(:params) {sane_defaults.merge({
      :verify_checksum  => false,
      :checksum_type    => 'sha1',
    })}

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_checksum(false) }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_string(nil) }
    it { is_expected.to contain_archive__download('Oracle_VM_VirtualBox_Extension_Pack.tgz').with_digest_type('md5') }
    it { is_expected.to contain_exec('Oracle_VM_VirtualBox_Extension_Pack unpack').with_creates('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') }
  end

  context 'with bad checksum type' do
    let(:params) {sane_defaults.merge({ :checksum_type => 'invalid' })}

    it { is_expected.to raise_error(Puppet::Error, /Expected parameter \'checksum_type\' of \'Virtualbox::Extpack.* to have type Optional\[Enum/) }
  end
end
