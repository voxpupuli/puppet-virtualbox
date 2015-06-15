require 'puppet'
require 'spec_helper'

describe 'virtualbox', :type => :class do
  [
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :lsbdistid => 'Ubuntu',
      :lsbdistcodename => 'trusty',
      :operatingsystemrelease => '14.04',
      :puppetversion => Puppet.version
    }, {
      :osfamily => 'RedHat',
      :operatingsystem => "RedHat",
      :operatingsystemrelease => '6.5',
    }, {
      :osfamily => 'RedHat',
      :operatingsystem => 'Fedora',
      :operatingsystemrelease => '22',
    }, {
      :osfamily => 'Suse',
      :operatingsystem => "OpenSuSE",
      :operatingsystemrelease => '12.3',
    }
  ].each do |facts|
    context "on #{facts[:osfamily]}" do
      let(:facts) { facts }

      # Debian specific stuff
      #
      if facts[:osfamily] == 'Debian'
        context 'with $::puppetversion < 3.5.0' do
          let(:facts) {facts.merge({:puppetversion => '3.4.3'})}
          it { should_not contain_class('apt') }
          it { should_not contain_apt__source('virtualbox') }
        end

        unless Puppet::Util::Package.versioncmp(facts[:puppetversion], '3.5.0') == -1
          it { should contain_class('apt') }
          it { should contain_apt__source('virtualbox').with_location('http://download.virtualbox.org/virtualbox/debian') }

          context 'with a custom version' do
            let(:params) {{ 'version' => '4.2' }}
            it { should contain_package('virtualbox').with_name('virtualbox-4.2').with_ensure('present') }
          end

          context 'when not managing the package repository' do
            let(:params) {{ 'manage_repo' => false }}
            it { should_not contain_apt__source('virtualbox') }
            it { should_not contain_class('apt') }
          end

          context 'when managing the package and the repository' do
            it { should contain_apt__source('virtualbox').that_comes_before('Package[virtualbox]') }
          end
        end
      end

      # RedHat specific stuff
      #
      if facts[:osfamily] == 'RedHat'
        case facts[:operatingsystem]
        when 'Fedora'
          it { should contain_yumrepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/fedora/$releasever/$basearch').with_gpgkey('https://www.virtualbox.org/download/oracle_vbox.asc') }
        else
          it { should contain_yumrepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch').with_gpgkey('https://www.virtualbox.org/download/oracle_vbox.asc') }
        end

        context 'with a custom version' do
          let(:params) {{ 'version' => '4.2' }}
          it { should contain_package('virtualbox').with_name('VirtualBox-4.2').with_ensure('present') }
        end

        context 'when not managing the package repository' do
          let(:params) {{ 'manage_repo' => false }}
          it { should_not contain_yumrepo('virtualbox') }
        end

        context 'when managing the package and the repository' do
          it { should contain_yumrepo('virtualbox').that_comes_before('Package[virtualbox]') }
        end

        context 'when managing the ext repo and the kernel' do
          let(:params) {{ "manage_ext_repo" => true, "manage_kernel" => true }}
          it { should contain_class('epel').that_comes_before('Class[virtualbox::kernel]') }
        end

        context 'when managing the kernel, but not the ext repo' do
          let(:params) {{ "manage_ext_repo" => false, "manage_kernel" => true }}
          it { should contain_class('virtualbox::kernel') }
          it { should_not contain_class('epel') }
        end
      end

      # Suse specific stuff
      #
      if facts[:osfamily] == 'Suse'
        it { should contain_zypprepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/opensuse/12.3') }

        context 'with a custom version' do
          let(:params) {{ 'version' => '4.2' }}
          it { should contain_package('virtualbox').with_name('VirtualBox-4.2').with_ensure('present') }
        end

        context 'when not managing the package repository' do
          let(:params) {{ 'manage_repo' => false }}
          it { should_not contain_zypprepo('virtualbox') }
        end

        context 'when managing the package and the repository' do
          it { should contain_zypprepo('virtualbox').that_comes_before('Package[virtualbox]') }
        end

        context 'with manage_repo => true on an unsupported version' do
          let(:facts) {facts.merge({:operatingsystemrelease => '13.1' })}
          let(:params) {{ 'manage_repo' => true }}
          it { is_expected.to raise_error(Puppet::Error, /manage your own repo/) }
        end
      end

      # Non $::osfamily specific stuff
      #
      it { should compile.with_all_deps }

      it { should contain_package('virtualbox') }

      context 'when managing the kernel' do
        let(:params) {{ 'manage_kernel' => true }}
        it { should contain_class('virtualbox::kernel').that_requires('Class[virtualbox::install]') }
      end

      context 'when not managing the kernel' do
        let(:params) {{ 'manage_kernel' => false }}
        it { should_not contain_class('virtualbox::kernel') }
      end

      context 'when not managing the package' do
        let(:params) {{ 'manage_package' => false }}
        it { should_not contain_packge('virtualbox') }
      end

      context 'with a custom package name and version' do
        let(:params) {{
          'package_name' => 'virtualbox-custom-package-name',
          'version' => '4.2',
        }}
        it { should contain_package('virtualbox').with_name('virtualbox-custom-package-name').with_ensure('present') }
      end

      context 'with a custom package name' do
        let(:params) {{ 'package_name' => 'virtualbox-custom-package-name' }}
        it { should contain_package('virtualbox').with_name('virtualbox-custom-package-name').with_ensure('present') }
      end

      context 'with a custom package_ensure value' do
        let(:params) {{ 'package_ensure' => '4.3.16-95972' }}
        it { should contain_package('virtualbox').with_ensure('4.3.16-95972') }
      end
    end
  end
end
