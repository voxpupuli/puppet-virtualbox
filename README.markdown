[![Puppet Forge](http://img.shields.io/puppetforge/v/danzilio/virtualbox.svg?style=flat)](https://forge.puppetlabs.com/danzilio/virtualbox) [![Build Status](https://travis-ci.org/danzilio/danzilio-virtualbox.svg)](https://travis-ci.org/danzilio/danzilio-virtualbox) [![Documentation Status](http://img.shields.io/badge/docs-puppet--strings-ff69b4.svg?style=flat)](http://danzilio.github.io/danzilio-virtualbox)

This module installs VirtualBox on a Linux host using the official repositories or custom defined repositories. By default, this module will also configure the kernel modules required to run VirtualBox.

By default, this module will install the Oracle VirtualBox yum/apt repo (see the [Note for Debian/Ubuntu Users using Puppet < 3.0.0](#note-for-debianubuntu-users-using-puppet--300) below), install the VirtualBox package, and build the VirtualBox kernel modules. You can define a custom package name and/or version, you can also opt to not manage the repositories with this module. Because of the strange convention Oracle has opted to use for versioning VirtualBox, if you set a custom package name, the `version` parameter will be ignored. If you wish to define a package version with a custom package name, you must use the `package_ensure` parameter.

## Support

This module is tested with:

- CentOS 5.11
- CentOS 6.6
- CentOS 7.0
- Debian 6.0.10
- Debian 7.8
- Ubuntu 10.04
- Ubuntu 12.04
- Ubuntu 14.04

It may work on other distros and OS versions, but these are the versions that we're targeting. If you wish to see another distro/version added to this list, so would we! PRs are welcome :)

This module is tested with the latest version of Puppet 2.7 as well as all minor versions of Puppet 3 and Puppet 4; all Puppet supported versions of Ruby are included in the test matrix. If you're interested in the testing matrix, please have a look at the `.travis.yml` file in the root of the module.

## Usage

### Installation

To begin using the virtualbox module, just include the virtualbox class on your node like so:

    include virtualbox

This will get you set up with the basics and will meet 90% of the use cases out there.

If you wish to manage your package repositories outside of this module, you just need to set `$manage_repo` to `false`:

    class { 'virtualbox':
      manage_repo => false,
    }

You can also specify a custom package name like so:

    class { 'virtualbox':
      manage_repo  => false,
      package_name => 'virtualbox-custom',
    }

The peculiar versioning in use by Oracle has forced us to do some funky stuff with versioning. If you're using the default package name, this module will concatenate `$package_name` and `$version` together with a dash between them. If you opt to define your own package name, the `$version` parameter is ignored completely and the only way to specify a version would be to use the `$package_ensure` parameter:

    class { 'virtualbox':
      manage_repo    => false,
      package_name   => 'virtualbox-custom',
      package_ensure => '4.3.18_96516',
    }

If you don't want to install the VirtualBox kernel extensions, you can set the `manage_kernel` parameter to `false`.

    class { 'virtualbox':
      manage_kernel => false,
    }

You can also opt to not manage the package with the `manage_package` parameter. This would effectively just install the package repository:

    class { 'virtualbox':
      manage_kernel  => false,
      manage_package => false,
    }

### Extension Pack

There's a defined type to install an Extension Pack. I'm not aware of any extension packs other than the Oracle Extension Pack, but this type should work for third party extensions. You can install Oracle's Extension Pack (adding support for USB 2.0, access to webcam, RDP and E1000 PXE ROM) like so:

    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure           => present,
      source           => 'http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20.vbox-extpack',
      checksum_string  => '4b7546ddf94308901b629865c54d5840',
      follow_redirects => true,
    }

This will download the extension pack, check to make sure the downloaded file matches the expected md5sum, then install the extension pack to `/usr/lib/virtualbox/ExtensionPacks`.

### Managing VMs

This module supports many common settings used when managing VMs in Oracle VirtualBox. It allows you to define VMs in code and have their configurations managed.

Note that it will take 2 runs to set up a VM from scratch, one to create the VM and another to set it's settings. There is also a limitation applied by VirtualBox that most settings cannot be changed while the VM is running. In this instance virtual_machine resources will fail with an error message reminding you to turn off the VM so that changes can be made.

This module introduces the `virtual_machine` resource type. It represents a single VM under VirtualBox and can manage many of it's settings.

The most basic configuration is as follows:

```puppet
virtual_machine{ 'puppet_test':
  ensure => present
}
```

Create a Windows 8.1 x64 VM with 2GB of RAM and 2 CPUs:

```puppet
virtual_machine { 'puppet_test':
  ensure          => present,
  ostype          => 'Windows81_64',
  memory          => 2048,
  cpus            => 2
}
```

Create an incredibly specific VM:

```puppet
virtual_machine { 'puppet_test':
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
  cpus            => 2,
  cpuexecutioncap => 100,
  monitorcount    => 3,
  accelerate3d    => 'off',
  firmware        => 'BIOS',
  boot1           => 'net',
  boot2           => 'dvd',
  boot3           => 'disk',
  boot4           => 'none',
  io_apic          => 'on',
  nics            => {
    1 => {
      mode  => 'nat',
      type  => 'Am79C973',
      speed => 0
    },
    2 => {
      mode  => 'bridged',
      type  => 'Am79C973',
      speed => 0
    }
  }
}
```


#### Parameters

* `ensure`: The standard ensure parameter

* `ostype`: OS Type of the VM, can be one of the following:
    * `Other`
    * `Other_64`
    * `Windows31`
    * `Windows95`
    * `Windows98`
    * `WindowsMe`
    * `WindowsNT4`
    * `Windows2000`
    * `WindowsXP`
    * `WindowsXP_64`
    * `Windows2003`
    * `Windows2003_64`
    * `WindowsVista`
    * `WindowsVista_64`
    * `Windows2008`
    * `Windows2008_64`
    * `Windows7`
    * `Windows7_64`
    * `Windows8`
    * `Windows8_64`
    * `Windows81`
    * `Windows81_64`
    * `Windows2012_64`
    * `Windows10`
    * `Windows10_64`
    * `WindowsNT`
    * `WindowsNT_64`
    * `Linux22`
    * `Linux24`
    * `Linux24_64`
    * `Linux26`
    * `Linux26_64`
    * `ArchLinux`
    * `ArchLinux_64`
    * `Debian`
    * `Debian_64`
    * `OpenSUSE`
    * `OpenSUSE_64`
    * `Fedora`
    * `Fedora_64`
    * `Gentoo`
    * `Gentoo_64`
    * `Mandriva`
    * `Mandriva_64`
    * `RedHat`
    * `RedHat_64`
    * `Turbolinux`
    * `Turbolinux_64`
    * `Ubuntu`
    * `Ubuntu_64`
    * `Xandros`
    * `Xandros_64`
    * `Oracle`
    * `Oracle_64`
    * `Linux`
    * `Linux_64`
    * `Solaris`
    * `Solaris_64`
    * `OpenSolaris`
    * `OpenSolaris_64`
    * `Solaris11_64`
    * `FreeBSD`
    * `FreeBSD_64`
    * `OpenBSD`
    * `OpenBSD_64`
    * `NetBSD`
    * `NetBSD_64`
    * `OS2Warp3`
    * `OS2Warp4`
    * `OS2Warp45`
    * `OS2eCS`
    * `OS2`
    * `MacOS`
    * `MacOS_64`
    * `MacOS106`
    * `MacOS106_64`
    * `MacOS107_64`
    * `MacOS108_64`
    * `MacOS109_64`
    * `DOS`
    * `Netware`
    * `L4`
    * `QNX`
    * `JRockitVE`

* `register`: Weather to register the VM when it is created, I have no idea why you would not do this so it's default is true

* `state`: Either `running` or `stopped`

* `description`: Self explanatory. Defaults to "Managed by Puppet, do not modify settings using the VirtualBox GUI"

* `memory`: Amount of RAM in MB

* `pagefusion`: `on` or `off`

* `vram`: Amount of VRAM in MB

* `acpi`: `on` or `off`

* `nestedpaging`: `on` or `off`

* `largepages`: `on` or `off`

* `longmode`: `on` or `off`

* `synthcpu`: `on` or `off`

* `hardwareuuid`: I don't know why you would want to change this, but you can!

* `cpus`: Number of virtual CPUs

* `cpuexecutioncap`: Sets the maximum % pr physical CPU to use

* `monitorcount`: Number of monitors

* `accelerate3d`: `on` or `off`

* `firmware`: Which firmware to use, possible values:
    * `BIOS`
    * `EFI`
    * `EFI32`
    * `EFI64`

* `boot1`: 1st boot device

* `boot2`: 2nd boot device

* `boot3`: 3rd boot device

* `boot4`: 4th boot device

* `io_apic`: `on` or `off` **Required to be `on` for multiple CPUs**

* `nics`: A hash of the NICs to install on the VM. The hash key is the NIC number and the value is a nested hash of it's settings. These are:
    * `mode`: The mode of the controller, can be:
        * `none`
        * `null`
        * `nat`
        * `bridged`
        * `intnet`
        * `generic`
        * `natnetwork`
    * `type`: Either `Am79C970A` or `Am79C973`
    * `speed`: The speed

**NOTE:** It is possible to pass in incomplete hashes to manage only certain aspects of each NIC, you don't have to specify every parameter.


## Note for Debian/Ubuntu Users using Puppet < 3.0.0

This module depends on `puppetlabs/apt` >= 2.1.0 which has dropped support for Puppet < 3.0.0. While this module is still compatible with Puppet 2.7 and above, Debian/Ubuntu users on Puppet < 3.0.0 will no longer be able to manage the VirtualBox repository with this module. The default `manage_repo` setting for Debian/Ubuntu with Puppet < 3.0.0 is `false`, but remains `true` for all other `puppetversion` and `operatingsystemversion` combinations. Unfortunately, I am not able to express this nuance in the module metadata, so these users will need to work around the dependency resolution in the `puppet module` tool. I apologize for the inconvenience.


## Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered. If you need help, just ask!
