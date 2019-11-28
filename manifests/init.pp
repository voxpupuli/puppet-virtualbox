# @summary Installs VirtualBox.
#
# @param version The major version of the package to install.
# @param package_ensure
#   This gets passed to the package resource as the value of the 'ensure'
#   parameter. This can be used to specify a package version.
# @param manage_repo
#   Should this module manage the package repository?
#   Defaults to true
# @param manage_ext_repo
#   On applicable platforms, should this module manage the external dependency
#   repository when `manage_kernel` is set to true?
#   Defaults to true
# @param repo_proxy proxy used by yum
# @param manage_package
#   Should this module manage the package?
#   Defaults to true
# @param manage_kernel
#   Should this module install the VirtualBox kernel modules?
#   Defaults to true
# @param vboxdrv_dependencies
#   Dependencies for building the VirtualBox kernel modules.
#   Defaults depend on the platform. See virtualbox::params.
# @param package_name
#   The name of the package to install. This must be the full packge name when
#   not the default. When the default is in use, it gets compounded with the
#   major.minor components of the version number.
#   Defaults to 'VirtualBox' for RedHat and 'virtualbox' for Debian
#
class virtualbox (
  String $version               = '6.0',
  String $package_ensure        = 'present',
  String $package_name          = $virtualbox::params::package_name,
  Boolean $manage_repo          = $virtualbox::params::manage_repo,
  Boolean $manage_ext_repo      = true,
  Boolean $manage_package       = true,
  Boolean $manage_kernel        = true,
  Array $vboxdrv_dependencies   = $virtualbox::params::vboxdrv_dependencies,
  Optional[String] $repo_proxy  = undef,
) inherits virtualbox::params {

  if versioncmp($version, '5.0') == -1 {
    $vboxdrv_command = '/etc/init.d/vboxdrv'
  } else {
    $vboxdrv_command = '/usr/lib/virtualbox/vboxdrv.sh'
  }

  class { 'virtualbox::install': } -> Class['virtualbox']

  if $manage_kernel {
    Class['virtualbox::install'] -> class { 'virtualbox::kernel': }

    if $facts['os']['family'] == 'RedHat' {
      if $manage_ext_repo {
        include epel
        Class['epel'] -> Class['virtualbox::kernel']
      }
    }
  }
}
