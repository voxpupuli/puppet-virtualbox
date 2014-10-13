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
          it { should return_exit_status 0 }
          it { should return_stdout(/^4.3/) }
        end

        describe command("/etc/init.d/vboxdrv status") do
          it { should return_exit_status 0 }
          it { should return_stdout(/VirtualBox kernel modules \(.*\) are loaded\./) }
        end
    end
end
