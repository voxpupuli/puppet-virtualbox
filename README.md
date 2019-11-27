# virtualbox

[![Build Status](https://travis-ci.org/voxpupuli/puppet-virtualbox.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-virtualbox)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-virtualbox/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-virtualboc)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/virtualbox.svg)](https://forge.puppetlabs.com/puppet/virtualbox)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/virtualbox.svg)](https://forge.puppetlabs.com/puppet/virtualbox)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/virtualbox.svg)](https://forge.puppetlabs.com/puppet/virtualbox)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/virtualbox.svg)](https://forge.puppetlabs.com/puppet/virtualbox)

This module installs VirtualBox on a Linux host using the official repositories or custom defined repositories. By default, this module will also configure the kernel modules required to run VirtualBox.

By default, this module will install the Oracle VirtualBox yum/apt repo, install the VirtualBox package, and build the VirtualBox kernel modules. You can define a custom package name and/or version, you can also opt to not manage the repositories with this module. Because of the strange convention Oracle has opted to use for versioning VirtualBox, if you set a custom package name, the `version` parameter will be ignored. If you wish to define a package version with a custom package name, you must use the `package_ensure` parameter.

## Support

This module is tested with:

- CentOS 6
- CentOS 7
- Debian 8
- Debian 9
- Ubuntu 16.04

It may work on other distros and OS versions, but these are the versions that we're targeting. If you wish to see another distro/version added to this list, so would we! PRs are welcome :)

This module is tested with the latest version Puppet 4 and Puppet 5; all Puppet supported versions of Ruby are included in the test matrix. If you're interested in the testing matrix, please have a look at the `.travis.yml` file in the root of the module.

## Usage

To begin using the virtualbox module, just include the virtualbox class on your node like so:

```puppet
include virtualbox
```

This will get you set up with the basics and will meet 90% of the use cases out there.

If you wish to manage your package repositories outside of this module, you just need to set `$manage_repo` to `false`:

```puppet
class { 'virtualbox':
  manage_repo => false,
}
```

You can also specify a custom package name like so:

```puppet
class { 'virtualbox':
  manage_repo  => false,
  package_name => 'virtualbox-custom',
}
```

You can also specify the version of the desired version `6.x`. If the host is already running a lower version of virtualbox, it is upgraded. If the host is not yet running virtualbox, it is installed.

```puppet
class { 'virtualbox':
  version => '6.1',
}
```

The peculiar versioning in use by Oracle has forced us to do some funky stuff with versioning. If you're using the default package name, this module will concatenate `$package_name` and `$version` together with a dash between them. If you opt to define your own package name, the `$version` parameter is ignored completely and the only way to specify a version would be to use the `$package_ensure` parameter:

```puppet
class { 'virtualbox':
  manage_repo    => false,
  package_name   => 'virtualbox-custom',
  package_ensure => '4.3.18_96516',
}
```

If you don't want to install the VirtualBox kernel extensions, you can set the `manage_kernel` parameter to `false`.

```puppet
class { 'virtualbox':
  manage_kernel => false,
}
```

You can also opt to not manage the package with the `manage_package` parameter. This would effectively just install the package repository:

```puppet
class { 'virtualbox':
  manage_kernel  => false,
  manage_package => false,
}
```

### Extension Pack

NOTE: To use this feature, you must have either [camptocamp/archive](https://forge.puppet.com/camptocamp/archive) or [puppet/archive](https://forge.puppet.com/puppet/archive) installed.

There's a defined type to install an Extension Pack. I'm not aware of any extension packs other than the Oracle Extension Pack, but this type should work for third party extensions. You can install Oracle's Extension Pack (adding support for USB 2.0, access to webcam, RDP and E1000 PXE ROM) like so:

```puppet
  virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
    ensure           => present,
    source           => 'http://download.virtualbox.org/virtualbox/6.0.0_RC1/Oracle_VM_VirtualBox_Extension_Pack-6.0.0_RC1.vbox-extpack',
    checksum_string  => 'deecf9b15ffda29d4d5da4349763fd11',
    follow_redirects => true,
  }
```

This will download the extension pack, check to make sure the downloaded file matches the expected md5sum, then install the extension pack to `/usr/lib/virtualbox/ExtensionPacks`.

## Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered. If you need help, just ask!
