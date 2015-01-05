require 'spec_helper'

describe 'virtualbox::extpack', :type => :class do
  [ { :osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'utopic' }, { :osfamily => 'RedHat', :operatingsystem => 'RedHat' } ].each do |os|
    context "on #{os['osfamily']}" do
      context 'when extpack needs to be installed' do
        let(:facts) { os }
        let(:params) { {
          :ensure  => 'present',
          :version => '4.3.20r96996'
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should contain_wget__fetch('download vbox extpack').with_source('http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should contain_wget__fetch('download vbox extpack').with_source('http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack').that_requires('Class[virtualbox::install]') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
      end

      context 'when extpack needs to be installed from custom URL' do
        let(:facts) { os }
        let(:params) { {
          :ensure  => 'present',
          :version => '4.3.20r96996',
          :source  => 'http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack'
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should contain_wget__fetch('download vbox extpack').with_source('http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should contain_wget__fetch('download vbox extpack').with_source('http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack').that_requires('Class[virtualbox::install]') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
      end

      context 'when extpack needs update' do
        let(:facts) { os.merge( { :virtualbox_extpack_version => '4.3.18r96516' } ) }
        let(:params) { {
          :ensure  => 'present',
          :version => '4.3.20r96996'
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should contain_wget__fetch('download vbox extpack').with_source('http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should contain_wget__fetch('download vbox extpack').with_source('http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack').that_requires('Class[virtualbox::install]') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
      end

      context 'when extpack needs update from custom URL' do
        let(:facts) { os.merge( { :virtualbox_extpack_version => '4.3.18r96516' } ) }
        let(:params) { {
          :ensure  => 'present',
          :version => '4.3.20r96996',
          :source  => 'http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack'
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should contain_wget__fetch('download vbox extpack').with_source('http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should contain_wget__fetch('download vbox extpack').with_source('http://myserver.example.com/Oracle_VM_VirtualBox_Extension_Pack-4.3.20-96996.vbox-extpack') }
          it { should contain_exec('install vbox extpack').that_requires('Class[virtualbox::install]') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
      end

      context 'when extpack is already up to date' do
        let(:facts) { os.merge( { :virtualbox_extpack_version => '4.3.20r96996' } ) }
        let(:params) { {
          :ensure  => 'present',    
          :version => '4.3.20r96996'
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should_not contain_wget__fetch('download vbox extpack') }
          it { should_not contain_exec('install vbox extpack') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should_not contain_wget__fetch('download vbox extpack') }
          it { should_not contain_exec('install vbox extpack').that_requires('Class[virtualbox::install]') }
          it { should_not contain_exec('uninstall vbox extpack') }
        end
      end

      context 'when extpack needs to be removed' do
        let(:facts) { os.merge( { :virtualbox_extpack_version => '4.3.20r96996' } ) }
        let(:params) { {
          :ensure  => 'absent',
        } }
        context 'Virtualbox not managed by Puppet' do
          it { should_not contain_wget__fetch('download vbox extpack') }
          it { should_not contain_exec('install vbox extpack') }
          it { should contain_exec('uninstall vbox extpack') }
        end
        context 'Virtualbox managed by Puppet as well' do
          let(:pre_condition) { 'include virtualbox' }
          it { should_not contain_wget__fetch('download vbox extpack') }
          it { should_not contain_exec('install vbox extpack') }
          it { should contain_exec('uninstall vbox extpack') }
        end
      end
    end
  end
end

