require 'spec_helper_acceptance'

describe 'virtualbox extpack' do
  context 'install extpack' do
    it 'should be idempotent' do
      pp = <<-EOS
      include virtualbox

      virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
        ensure           => present,
        source           => 'http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20.vbox-extpack',
        checksum_string  => '4b7546ddf94308901b629865c54d5840',
        follow_redirects => true,
      }
      EOS
    
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  
    describe file('/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack') do
      it { should be_directory }
    end
    
    describe file('/usr/src/Oracle_VM_VirtualBox_Extension_Pack.tgz') do
      it { should be_file }
      it { should match_md5checksum '4b7546ddf94308901b629865c54d5840' }
    end

    describe command("VBoxManage list extpacks") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /Extension Packs: 1/ }
    end
  end
  
  context 'uninstall extpack' do
    it 'should be idempotent' do
      pp1 = <<-EOS
      include virtualbox

      virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
        ensure           => present,
        source           => 'http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20.vbox-extpack',
        checksum_string  => '4b7546ddf94308901b629865c54d5840',
        follow_redirects => true,
      }
      EOS
      
      pp2 = <<-EOS
      include virtualbox

      virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
        ensure           => absent,
        source           => 'http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20.vbox-extpack',
        checksum_string  => '4b7546ddf94308901b629865c54d5840',
        follow_redirects => true,
      }
      EOS
    
      apply_manifest(pp1, :catch_failures => true)
      apply_manifest(pp2, :catch_failures => true)
      apply_manifest(pp2, :catch_changes => true)
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