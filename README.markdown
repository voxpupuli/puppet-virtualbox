[![Puppet Forge](http://img.shields.io/puppetforge/v/danzilio/virtualbox.svg)](https://forge.puppetlabs.com/danzilio/virtualbox) [![Build Status](https://travis-ci.org/danzilio/danzilio-virtualbox.svg)](https://travis-ci.org/danzilio/danzilio-virtualbox)

This module installs VirtualBox on a Linux host using the official repositories or custom defined repositories. By default, this module will also configure the kernel modules required to run VirtualBox.

By default, this module will install the Oracle VirtualBox yum/apt repo, install the VirtualBox package, and build the VirtualBox kernel modules. You can define a custom package name and/or version, you can also opt to not manage the repositories with this module. Because of the strange convention Oracle has opted to use for versioning VirtualBox, if you set a custom package name, the `version` parameter will be ignored. If you wish to define a package version with a custom package name, you must use the `package_ensure` parameter.

##Support

This module is tested with:

- CentOS 5.10
- CentOS 6.5
- Debian 6.0.7
- Debian 7.3
- Ubuntu 10.04
- Ubuntu 12.04
- Ubuntu 14.04

It may work on other distros and OS versions, but these are the versions that we're targeting. If you wish to see another distro/version added to this list, so would we! PRs are welcome :)

##Usage

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

##Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered.
