require 'spec_helper'

describe 'virtualbox', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_package('virtualbox') }

      context 'when managing the kernel' do
        let(:params) { { 'manage_kernel' => true } }

        it { is_expected.to contain_class('virtualbox::kernel').that_requires('Class[virtualbox::install]') }
      end

      context 'when not managing the kernel' do
        let(:params) { { 'manage_kernel' => false } }

        it { is_expected.not_to contain_class('virtualbox::kernel') }
      end

      context 'when not managing the package' do
        let(:params) { { 'manage_package' => false } }

        it { is_expected.not_to contain_package('virtualbox') }
      end

      context 'with a custom package name and version' do
        let(:params) do
          {
            'package_name' => 'virtualbox-custom-package-name',
            'version' => '4.2'
          }
        end

        it { is_expected.to contain_package('virtualbox').with_name('virtualbox-custom-package-name').with_ensure('present') }
      end

      context 'with the version parameter set to 5.0' do
        let(:params) { { 'version' => '5.0' } }

        it { is_expected.to contain_class('virtualbox::kernel').with_vboxdrv_command('/usr/lib/virtualbox/vboxdrv.sh') }
      end

      context 'with the version parameter set to < 5.0' do
        let(:params) { { 'version' => '4.3' } }

        it { is_expected.to contain_class('virtualbox::kernel').with_vboxdrv_command('/etc/init.d/vboxdrv') }
      end

      context 'with a custom package name' do
        let(:params) { { 'package_name' => 'virtualbox-custom-package-name' } }

        it { is_expected.to contain_package('virtualbox').with_name('virtualbox-custom-package-name').with_ensure('present') }
      end

      context 'with a custom package_ensure value' do
        let(:params) { { 'package_ensure' => '4.3.16-95972' } }

        it { is_expected.to contain_package('virtualbox').with_ensure('4.3.16-95972') }
      end

      # operating system specific tests
      case facts[:os]['family']
      when 'Debian'
        it { is_expected.to contain_class('apt') }
        it { is_expected.to contain_apt__source('virtualbox').with_location('http://download.virtualbox.org/virtualbox/debian').with_key('id' => 'B9F8D658297AF3EFC18D5CDFA2F683C52980AECF', 'source' => 'https://www.virtualbox.org/download/oracle_vbox_2016.asc') }

        context 'with a custom version' do
          let(:params) { { 'version' => '5.1' } }

          it { is_expected.to contain_package('virtualbox').with_name('virtualbox-5.1').with_ensure('present') }
        end

        context 'when not managing the package repository' do
          let(:params) { { 'manage_repo' => false } }

          it { is_expected.not_to contain_apt__source('virtualbox') }
          it { is_expected.not_to contain_class('apt') }
        end

        context 'when managing the package and the repository' do
          it { is_expected.to contain_apt__source('virtualbox').that_comes_before('Class[apt::update]') }
          it { is_expected.to contain_class('apt::update').that_comes_before('Package[virtualbox]') }
        end
      when 'RedHat'
        case facts[:os]['name']
        when 'Fedora'
          it { is_expected.to contain_yumrepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/fedora/$releasever/$basearch').with_gpgkey('https://www.virtualbox.org/download/oracle_vbox.asc') }
        else
          it { is_expected.to contain_yumrepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch').with_gpgkey('https://www.virtualbox.org/download/oracle_vbox.asc') }
        end

        context 'with a custom version' do
          let(:params) { { 'version' => '5.1' } }

          it { is_expected.to contain_package('virtualbox').with_name('VirtualBox-5.1').with_ensure('present') }
        end

        context 'when not managing the package repository' do
          let(:params) { { 'manage_repo' => false } }

          it { is_expected.not_to contain_yumrepo('virtualbox') }
        end

        context 'when managing the package and the repository' do
          it { is_expected.to contain_yumrepo('virtualbox').that_comes_before('Package[virtualbox]') }
        end

        context 'when managing the ext repo and the kernel' do
          let(:params) { { 'manage_ext_repo' => true, 'manage_kernel' => true } }

          it { is_expected.to contain_class('epel').that_comes_before('Class[virtualbox::kernel]') }
        end

        context 'when managing the kernel, but not the ext repo' do
          let(:params) { { 'manage_ext_repo' => false, 'manage_kernel' => true } }

          it { is_expected.to contain_class('virtualbox::kernel') }
          it { is_expected.not_to contain_class('epel') }
        end

        context 'when not specifying a repository proxy' do
          it { is_expected.to contain_yumrepo('virtualbox').with_proxy(nil) }
        end

        context 'when specifying a repository proxy' do
          let(:params) { { 'repo_proxy' => 'http://proxy:8080/' } }

          it { is_expected.to contain_yumrepo('virtualbox').with_proxy('http://proxy:8080/') }
        end
      when 'Suse'
        it { is_expected.to contain_zypprepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/opensuse/12.3') }

        context 'with a custom version' do
          let(:params) { { 'version' => '5.1' } }

          it { is_expected.to contain_package('virtualbox').with_name('VirtualBox-5.1').with_ensure('present') }
        end

        context 'when not managing the package repository' do
          let(:params) { { 'manage_repo' => false } }

          it { is_expected.not_to contain_zypprepo('virtualbox') }
        end

        context 'when managing the package and the repository' do
          it { is_expected.to contain_zypprepo('virtualbox').that_comes_before('Package[virtualbox]') }
        end

        context 'with manage_repo => true on an unsupported version' do
          let(:params) { { 'manage_repo' => true } }

          it { is_expected.to compile.and_raise_error(%r{manage your own repo}) }
        end
      else
        it { is_expected.to compile.and_raise_error(%r{not supported}) }
      end
    end
  end
end
