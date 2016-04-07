require 'spec_helper_acceptance'

authors = ['camptocamp', 'puppet']

describe 'virtualbox extpack' do
  let(:install) do <<-EOS
    include virtualbox

    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure           => present,
      source           => 'http://download.virtualbox.org/virtualbox/5.0.16/Oracle_VM_VirtualBox_Extension_Pack-5.0.16-105871.vbox-extpack',
      checksum_string  => '41f1d66e0be1c183917c95efed89db56',
      follow_redirects => true,
    }
    EOS
  end

  let(:uninstall) do <<-EOS
    include virtualbox

    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure           => absent,
      source           => 'http://download.virtualbox.org/virtualbox/5.0.16/Oracle_VM_VirtualBox_Extension_Pack-5.0.16-105871.vbox-extpack',
      checksum_string  => '41f1d66e0be1c183917c95efed89db56',
      follow_redirects => true,
    }
    EOS
  end

  authors.each do |author|
    context "with #{author}/archive" do
      before(:all) do
        hosts.each do |host|
          authors.each do |author|
            on host, puppet('module', 'uninstall', '-f', "#{author}-archive"), { :acceptable_exit_codes => [0,1] }
          end

          on host, puppet('module','install', "#{author}-archive")
        end
      end

      context 'install extpack' do
        it 'should be idempotent' do
          apply_manifest(install, :catch_failures => true)
          apply_manifest(install, :catch_changes => true)
        end

        describe file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') do
          it { should be_directory }
        end

        describe file('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz') do
          it { should be_file }
          its(:md5sum) { should eq '41f1d66e0be1c183917c95efed89db56' }
        end

        describe command("VBoxManage list extpacks") do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /Extension Packs: 1/ }
        end
      end

      context 'uninstall extpack' do
        it 'should be idempotent' do
          apply_manifest(install, :catch_failures => true)
          apply_manifest(uninstall, :catch_failures => true)
          apply_manifest(uninstall, :catch_changes => true)
        end

        describe file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') do
          it { should_not be_directory }
        end

        describe file('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz') do
          it { should_not be_file }
        end

        describe command("VBoxManage list extpacks") do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /Extension Packs: 0/ }
        end
      end
    end
  end
end
