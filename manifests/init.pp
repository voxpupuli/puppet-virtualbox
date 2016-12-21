# == Class: virtualbox
#
# This is a public class. This class installs VirtualBox.
#
# === Parameters
#
# [*version*]
#   The major version of the package to install.
#   Defaults to 5.0
# [*package_ensure*]
#   This gets passed to the package resource as the value of the 'ensure'
#   parameter. This can be used to specify a package version.
#   Defaults to present
# [*manage_repo*]
#   Should this module manage the package repository?
#   Defaults to true
# [*manage_ext_repo*]
#   On applicable platforms, should this module manage the external dependency
#   repository when `manage_kernel` is set to true?
#   Defaults to true
# [*manage_package*]
#   Should this module manage the package?
#   Defaults to true
# [*manage_kernel*]
#   Should this module install the VirtualBox kernel modules?
#   Defaults to true
# [*vboxdrv_dependencies*]
#   Dependencies for building the VirtualBox kernel modules.
#   Defaults depend on the platform. See virtualbox::params.
# [*package_name*]
#   The name of the package to install. This must be the full packge name when
#   not the default. When the default is in use, it gets compounded with the
#   major.minor components of the version number.
#   Defaults to 'VirtualBox' for RedHat and 'virtualbox' for Debian
#
class virtualbox (
  $version              = $virtualbox::params::version,
  $package_ensure       = $virtualbox::params::package_ensure,
  $manage_repo          = $virtualbox::params::manage_repo,
  $manage_ext_repo      = $virtualbox::params::manage_ext_repo,
  $repo_proxy           = $virtualbox::params::repo_proxy,
  $manage_package       = $virtualbox::params::manage_package,
  $manage_kernel        = $virtualbox::params::manage_kernel,
  $vboxdrv_dependencies = $virtualbox::params::vboxdrv_dependencies,
  $package_name         = $virtualbox::params::package_name
) inherits virtualbox::params {

  if versioncmp($::puppetversion, '4.0.0') == -1 {
    warning 'Support for Puppet < 3.0 is deprecated. Version 2.0 of this module will only support Puppet >= 4.0' # lint:ignore:80chars
  }

  if versioncmp($version, '5.0') == -1 {
    $vboxdrv_command = '/etc/init.d/vboxdrv'
  } else {
    $vboxdrv_command = '/usr/lib/virtualbox/vboxdrv.sh'
  }

  validate_bool($manage_repo)
  validate_bool($manage_ext_repo)
  validate_bool($manage_package)
  validate_bool($manage_kernel)
  validate_string($package_name)

  class { '::virtualbox::install': } -> Class['virtualbox']

  if $manage_kernel {
    validate_array($vboxdrv_dependencies)
    Class['virtualbox::install'] -> class { '::virtualbox::kernel': }

    if $::osfamily == 'RedHat' {
      if $manage_ext_repo {
        include ::epel
        Class['epel'] -> Class['virtualbox::kernel']
      }
    }
  }

}
