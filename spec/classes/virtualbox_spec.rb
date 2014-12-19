require 'spec_helper'

describe 'virtualbox', :type => :class do
    ['Debian', 'RedHat'].each do |osfamily|
        context "on #{osfamily}" do
            # Debian specific stuff
            #
            if osfamily == 'Debian'
                let(:facts) {{
                    :osfamily => osfamily,
                    :operatingsystem => 'Ubuntu',
                    :lsbdistid => 'Ubuntu',
                    :lsbdistcodename => 'trusty',
                    :operatingsystemrelease => '14.04',
                }}

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

            # RedHat specific stuff
            #
            if osfamily == 'RedHat'
                let(:facts) {{
                    :osfamily => osfamily,
                    :operatingsystem => "RedHat",
                    :operatingsystemrelease => '6.5',
                }}

                it { should contain_yumrepo('virtualbox').with_baseurl('http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch').with_gpgkey('https://www.virtualbox.org/download/oracle_vbox.asc') }

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

                context 'when managing the repo and the kernel' do
                  it { should contain_class('epel').that_comes_before('Class[virtualbox::kernel]') }
                end
            end

            # Non $::osfamily specific stuff
            #
            it { should compile.with_all_deps }
            #it { should contain_class('virtualbox::install').that_comes_before('virtualbox::config') }
            #it { should contain_class('virtualbox::service').that_subscribes_to('virtualbox::config') }
            #it { should contain_class('virtualbox::config') }

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

