# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'virtualbox class' do
  virtualbox_versions = ['5.0', '5.1', '5.2', '6.0', '6.1', '7.0']

  test_from = case fact('os.name')
              when 'CentOS', 'RedHat'
                '7.0'
              when 'Ubuntu'
                case fact('os.release.major')
                when '18.04'
                  '5.1'
                when '20.04'
                  '6.0'
                end
              when 'Debian'
                case fact('os.release.major')
                when '10'
                  '6.0'
                when '11'
                  '6.1'
                end
              end

  version_sequence = virtualbox_versions[virtualbox_versions.index(test_from)..]

  version_sequence.each do |version|
    package_name = case fact('osfamily')
                   when 'RedHat'
                     "VirtualBox-#{version}"
                   else
                     "virtualbox-#{version}"
                   end

    context "with version parameter to #{version}" do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-EOS
          class { 'virtualbox':
            version => '#{version}',
          }
          EOS
        end
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end

      describe command('VBoxManage --version') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match Regexp.new("^#{Regexp.escape(version)}") }
      end

      describe command('/usr/lib/virtualbox/vboxdrv.sh status') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match %r{VirtualBox kernel modules \(.*\) are loaded\.} }
      end

      describe command('modinfo vboxdrv') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match %r{version:.* #{Regexp.escape(version)}} }
      end
    end
  end
end
