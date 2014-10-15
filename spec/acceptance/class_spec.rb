require 'spec_helper_acceptance'

describe 'virtualbox class' do

  case fact('osfamily')
  when 'RedHat'
    package_name = 'VirtualBox-4.3'
  else
    package_name = 'virtualbox-4.3'
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
          its(:stdout) { should match /^4.3/ }
        end

        describe command("/etc/init.d/vboxdrv status") do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /VirtualBox kernel modules \(.*\) are loaded\./ }
        end
    end
end
