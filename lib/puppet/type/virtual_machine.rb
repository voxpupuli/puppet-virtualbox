Puppet::Type.newtype(:virtual_machine) do
  @doc = "Create a new VirtualBox VM."
  
  # Calling ensurable means that we can use:
  #   ensure => present
  # on this resource
  ensurable

  # ... the code ...
  newparam(:name, :namevar => true) do
  	desc "The name of the VM, must not contain spaces"
  	newvalues(/[\S]+/)
  end

  newproperty(:groups, :array_matching => :all) do # :array_matching defaults to :first
    desc "Groups that the VM will belong to. (Optional)"
    # This little gem makes sure that when we are comparing the arrays
    # to see if they match up, we sort them first so that puppet doesn't
    # freak the fuck out
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:ostype) do
  	desc "OS type of the VM (Optional)"
    newvalues('Other' ,'Other_64' ,'Windows31' ,'Windows95' ,'Windows98' ,
      'WindowsMe' ,'WindowsNT4' ,'Windows2000' ,'WindowsXP' ,'WindowsXP_64' ,
      'Windows2003' ,'Windows2003_64' ,'WindowsVista' ,'WindowsVista_64' ,
      'Windows2008' ,'Windows2008_64' ,'Windows7' ,'Windows7_64' ,'Windows8' ,
      'Windows8_64' ,'Windows81' ,'Windows81_64' ,'Windows2012_64' ,'Windows10' ,
      'Windows10_64' ,'WindowsNT' ,'WindowsNT_64' ,'Linux22' ,'Linux24' ,
      'Linux24_64' ,'Linux26' ,'Linux26_64' ,'ArchLinux' ,'ArchLinux_64' ,
      'Debian' ,'Debian_64' ,'OpenSUSE' ,'OpenSUSE_64' ,'Fedora' ,'Fedora_64' ,
      'Gentoo' ,'Gentoo_64' ,'Mandriva' ,'Mandriva_64' ,'RedHat' ,'RedHat_64' ,
      'Turbolinux' ,'Turbolinux_64' ,'Ubuntu' ,'Ubuntu_64' ,'Xandros' ,
      'Xandros_64' ,'Oracle' ,'Oracle_64' ,'Linux' ,'Linux_64' ,'Solaris' ,
      'Solaris_64' ,'OpenSolaris' ,'OpenSolaris_64' ,'Solaris11_64' ,'FreeBSD' ,
      'FreeBSD_64' ,'OpenBSD' ,'OpenBSD_64' ,'NetBSD' ,'NetBSD_64' ,'OS2Warp3' ,
      'OS2Warp4' ,'OS2Warp45' ,'OS2eCS' ,'OS2' ,'MacOS' ,'MacOS_64' ,'MacOS106' ,
      'MacOS106_64' ,'MacOS107_64' ,'MacOS108_64' ,'MacOS109_64' ,'DOS' ,
      'Netware' ,'L4' ,'QNX' ,'JRockitVE')
  end

  newparam(:register) do
  	desc "Weather or not to register the new Vm with VirtualBox (Optional)"
    defaultto :true
    newvalues(:true, :false)
  end

  newparam(:basefolder) do
    # TODO: Add path validation
  	desc "Location for the VM (Optional)"
  end

  newparam(:uuid) do
  	desc "UUID of the new VM (Optional)"
  end

  newproperty(:description) do
    defaultto "Managed by Puppet, do not modify settings using the VirtualBox GUI"
    desc "The description of the VM"
  end

  # I'm not going to do iconfile because its a param not a property
  # also who needs that, fuck 'em

  newproperty(:memory) do
    desc "memorysize in MB"
    newvalues(/\d+/)
  end

  newproperty(:pagefusion) do
    desc "pagefusion on or off"
    newvalues(/on|off/)
  end

  newproperty(:vram) do
    desc "vram size in MB"
    newvalues(/\d+/)
  end

  newproperty(:acpi) do
    desc "ACPI on or off"
    newvalues(/on|off/)
  end

  newproperty(:nestedpaging) do
    desc "Turn nested paging on or off"
    newvalues(/on|off/)
  end

  newproperty(:largepages) do
    desc "Turn large pages on or off"
    newvalues(/on|off/)
  end

  newproperty(:longmode) do
    desc "Turn longmode on or off"
    newvalues(/on|off/)
  end

  newproperty(:synthcpu) do
    desc "Turn synthcpu on or off"
    newvalues(/on|off/)
  end

  newproperty(:hardwareuuid) do
    desc "set the hardware UUID"
  end

  newproperty(:cpus) do
    desc "Manage the number of CPUs"
    newvalues(/\d+/)
  end

  newproperty(:cpuexecutioncap) do
    desc "Set the cpuexecutioncap"
    newvalues(/\d+/)
  end

  newproperty(:monitorcount) do
    desc "The number of monitors"
    newvalues(/\d+/)
  end

  newproperty(:accelerate3d) do
    desc "To accelerate3d, or not to accelerate3d, that is the question."
    newvalues(/on|off/)
  end

  newproperty(:firmware) do
    desc "What device"
    newvalues(/BIOS|EFI|EFI32|EFI64/)
  end

  newproperty(:boot1) do
    desc "What boot1 device to use: none|floppy|dvd|disk|net"
    newvalues(/none|floppy|dvd|disk|net/)
  end

  newproperty(:boot2) do
    desc "What boot2 device to use: none|floppy|dvd|disk|net"
    newvalues(/none|floppy|dvd|disk|net/)
  end

  newproperty(:boot3) do
    desc "What boot3 device to use: none|floppy|dvd|disk|net"
    newvalues(/none|floppy|dvd|disk|net/)
  end

  newproperty(:boot4) do
    desc "What boot4 device to use: none|floppy|dvd|disk|net"
    newvalues(/none|floppy|dvd|disk|net/)
  end

  newproperty(:nics) do
    desc "The NICs to use"
    # Override the default .insync? method
    def insync?(is)
      # Loop through each nic
      should.each do | nic_number, settings |
        # loop through each one of its settings
        settings.each do | name, value |
          # Check that in the current state the key (nic_number) that are we 
          # are trying to evaluat actually exists to avoid errors
          if is.has_key?(nic_number)
            if should[nic_number][name] != is[nic_number][name]
              return false
            end
          else
            return false
          end
        end
      end
    end
  end

  newproperty(:io_apic) do
    desc "This is required for more than 1 CPU"
    defaultto 'on'
    newvalues(/on|off/)
  end

  # THIS NEEDS TO BE AT THE END
  newproperty(:state) do
    desc "Weather the VM should be running or poweroff"
    defaultto 'running'
    newvalues('running', 'poweroff')
  end

end