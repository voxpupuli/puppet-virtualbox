require 'spec_helper_acceptance'

describe 'virtualbox class' do

  case fact('osfamily')
  when 'RedHat'
    package_name = 'VirtualBox-5.0'
  else
    package_name = 'virtualbox-5.0'
  end

  context 'default parameters' do
    it 'should be idempotent' do
      pp = <<-EOS
      class { 'virtualbox': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe command("VBoxManage --version") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /^5.0/ }
    end

    describe command("/usr/lib/virtualbox/vboxdrv.sh status") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /VirtualBox kernel modules \(.*\) are loaded\./ }
    end
  end
end
