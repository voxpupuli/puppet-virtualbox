require 'spec_helper_acceptance'

describe 'virtualbox class' do
  package_name = case fact('osfamily')
                 when 'RedHat'
                   'VirtualBox-5.1'
                 else
                   'virtualbox-5.1'
                 end
  upgraded_package_name52 = case fact('osfamily')
                            when 'RedHat'
                              'VirtualBox-5.2'
                            else
                              'virtualbox-5.2'
                            end
  upgraded_package_name60 = case fact('osfamily')
                            when 'RedHat'
                              'VirtualBox-6.0'
                            else
                              'virtualbox-6.0'
                            end

  context 'with version parameter to 5.1' do
    let(:pp) do
      <<-EOS
      class { 'virtualbox':
        version => '5.1',
      }
      EOS
    end

    it_behaves_like 'an idempotent puppet code'

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe command('VBoxManage --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^5.1} }
    end

    describe command('/usr/lib/virtualbox/vboxdrv.sh status') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{VirtualBox kernel modules \(.*\) are loaded\.} }
    end

    describe command('modinfo vboxdrv') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{version:.* 5\.1} }
    end
  end

  context 'version parameter to upgrade from 5.1 to 5.2' do
    let(:pp) do
      <<-EOS
      class { 'virtualbox':
        version => '5.2',
      }
      EOS
    end

    it_behaves_like 'an idempotent puppet code'

    describe package(upgraded_package_name52) do
      it { is_expected.to be_installed }
    end
    describe package(package_name) do
      it { is_expected.not_to be_installed }
    end

    describe command('VBoxManage --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^5.2} }
    end

    describe command('/usr/lib/virtualbox/vboxdrv.sh status') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{VirtualBox kernel modules \(.*\) are loaded\.} }
    end

    describe command('modinfo vboxdrv') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{version:.* 5\.2} }
    end
  end

  context 'version parameter to upgrade from 5.2 to 6.0' do
    let(:pp) do
      <<-EOS
      include virtualbox
      EOS
    end

    it_behaves_like 'an idempotent puppet code'

    describe package(upgraded_package_name60) do
      it { is_expected.to be_installed }
    end
    describe package(upgraded_package_name52) do
      it { is_expected.not_to be_installed }
    end

    describe command('VBoxManage --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^6.0} }
    end

    describe command('/usr/lib/virtualbox/vboxdrv.sh status') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{VirtualBox kernel modules \(.*\) are loaded\.} }
    end

    describe command('modinfo vboxdrv') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{version:.* 6\.0} }
    end
  end
end
