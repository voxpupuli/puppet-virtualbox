require 'spec_helper_acceptance'

describe 'virtualbox type/provider' do
  context 'creating a complex VM' do
    it 'should be idempotent after 2 runs' do
      pp = <<-EOS
      virtual_machine { 'computer':
        ensure          => present,
        ostype          => 'Other',
        register        => true,
        state           => 'running',
        description     => 'Managed by puppet',
        memory          => 512,
        pagefusion      => 'off',
        vram            => 16,
        acpi            => 'on',
        nestedpaging    => 'on',
        largepages      => 'on',
        longmode        => 'off',
        synthcpu        => 'off',
        hardwareuuid    => '3e039b44-0b67-4109-8936-f9e3ac519c9b',
        cpus            => 1,
        cpuexecutioncap => 100,
        monitorcount    => 1,
        accelerate3d    => 'off',
        firmware        => 'BIOS',
        boot1           => 'net',
        boot2           => 'dvd',
        boot3           => 'disk',
        boot4           => 'none',
        io_apic         => 'on',
        nics            => {
          1 => {
            mode  => 'nat',
            type  => 'Am79C973',
            speed => 0
          }
        }
      }
      EOS

      # We are applying the manifest twice here due to the fact that you have
      # to apply a manifest twice when creating a VM, I will look for a
      # workaround fo this at a later date.
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it 'should have been created' do
      command('VBoxManage showvminfo computer') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /Name:\s*computer/ }
      end
    end

    it 'should be running' do
      command('VBoxManage list runningvms') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /computer/ }
      end
    end

    it 'should have the correct settings' do
      command('VBoxManage showvminfo computer --machinereadable') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /description="Managed by puppet"/ }
        its(:stdout) { should match /type=Other\/Unknown/ }
        its(:stdout) { should match /memory=512/ }
        its(:stdout) { should match /pagefusion="off"/ }
        its(:stdout) { should match /vram=16/ }
        its(:stdout) { should match /acpi="on"/ }
        its(:stdout) { should match /nestedpaging="on"/ }
        its(:stdout) { should match /largepages="on"/ }
        its(:stdout) { should match /longmode="off"/ }
        its(:stdout) { should match /synthcpu="off"/ }
        its(:stdout) { should match /hardwareuuid="3e039b44-0b67-4109-8936-f9e3ac519c9b"/ }
        its(:stdout) { should match /cpus=1/ }
        its(:stdout) { should match /cpuexecutioncap=100/ }
        its(:stdout) { should match /monitorcount=1/ }
        its(:stdout) { should match /accelerate3d="off"/ }
        its(:stdout) { should match /firmware="BIOS"/ }
        its(:stdout) { should match /boot1="net"/ }
        its(:stdout) { should match /boot2="dvd"/ }
        its(:stdout) { should match /boot3="disk"/ }
        its(:stdout) { should match /boot4="none"/ }
        its(:stdout) { should match /nic1="nat"/ }
        its(:stdout) { should match /nictype1="Am79C973"/ }
        its(:stdout) { should match /nicspeed1=0/ }
        its(:stdout) { should match /io_apic="on"/ }
      end
    end

  context 'stopping a complex vm' do
    it 'should be able to shut down the machine' do
      pp = <<-EOS
      virtual_machine { 'computer':
        ensure          => present,
        ostype          => 'Other',
        register        => true,
        state           => 'poweroff',
        description     => 'Managed by puppet',
        memory          => 512,
        pagefusion      => 'off',
        vram            => 16,
        acpi            => 'on',
        nestedpaging    => 'on',
        largepages      => 'on',
        longmode        => 'off',
        synthcpu        => 'off',
        hardwareuuid    => '3e039b44-0b67-4109-8936-f9e3ac519c9b',
        cpus            => 1,
        cpuexecutioncap => 100,
        monitorcount    => 1,
        accelerate3d    => 'off',
        firmware        => 'BIOS',
        boot1           => 'net',
        boot2           => 'dvd',
        boot3           => 'disk',
        boot4           => 'none',
        io_apic         => 'on',
        nics            => {
          1 => {
            mode  => 'nat',
            type  => 'Am79C973',
            speed => 0
          }
        }
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'modifying a complex vm' do
    # Create a couple of commands so that we can be sure the server will start
    # with the new settings
    start_vm = 'VBoxManage startvm computer --type headless'
    stop_vm = 'VBoxManage controlvm computer poweroff'

    it 'should be able to change the settings' do
      # I realise this only changes some of the settings, but not all of the
      # settings work together and I can't be jazzed working out which goes
      # with which.
      pp = <<-EOS
      virtual_machine { 'computer':
        ensure          => present,
        ostype          => 'Other_64',
        register        => true,
        state           => 'poweroff',
        description     => 'I forgot to have lunch',
        memory          => 256,
        pagefusion      => 'off',
        vram            => 8,
        acpi            => 'on',
        nestedpaging    => 'on',
        largepages      => 'on',
        longmode        => 'off',
        synthcpu        => 'off',
        hardwareuuid    => '3e039b44-0b67-4109-8936-f9e3ac519c9b',
        cpus            => 1,
        cpuexecutioncap => 50,
        monitorcount    => 2,
        accelerate3d    => 'off',
        firmware        => 'BIOS',
        boot1           => 'disk',
        boot2           => 'net',
        boot3           => 'dvd',
        boot4           => 'none',
        io_apic         => 'on',
        nics            => {
          1 => {
            mode  => 'nat',
            type  => 'Am79C973',
            speed => 0
          }
        }
      }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it 'should be able to boot with the new settings' do
      pp = <<-EOS
      virtual_machine { 'computer':
        ensure          => present,
        state           => 'running',
      }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'deleting a complex vm' do
    it 'should be able to remove a vm' do
      pp = <<-EOS
      virtual_machine { 'computer':
        ensure          => absent,
      }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end