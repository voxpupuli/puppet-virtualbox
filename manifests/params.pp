# == Class virtualbox::params
#
# This class is meant to be called from virtualbox
# It sets variables according to platform
#
class virtualbox::params {
  $manage_ext_repo = true
  $repo_proxy      = undef

  case $::osfamily {
    'Debian': {
      $version = '5.0'
      $manage_kernel = true
      $manage_package = true
      $package_ensure = present
      $package_name = 'virtualbox'

      if versioncmp($::puppetversion, '3.0.0') == -1 {
        notice "The default behavior for the manage_repo parameter has changed for ${::puppetversion} on Debian/Ubuntu systems. You must now manage Apt repos separate from the virtualbox module. See the README.md for more details." # lint:ignore:80chars
        $manage_repo = false
      } else {
        $manage_repo = true
      }

      $vboxdrv_dependencies = [
        'dkms',
        "linux-headers-${::kernelrelease}",
        'build-essential',
      ]

    }
    'RedHat': {
      $version = '5.0'
      $manage_kernel = true
      $manage_package = true
      $manage_repo = true
      $package_ensure = present
      $package_name = 'VirtualBox'
      $vboxdrv_dependencies = [
        'gcc',
        'make',
        'patch',
        'kernel-headers',
        'kernel-devel',
        'dkms',
        'binutils',
        'glibc-headers',
        'glibc-devel'
      ]
    }
    'Suse': {
      warning('Careful! Support for SuSE is experimental at best.')
      $version = '5.0'
      $manage_kernel = true
      $manage_package = true
      $manage_repo = true
      $package_ensure = present
      $package_name = 'VirtualBox'
      $vboxdrv_dependencies = [
        'gcc',
        'make',
        'patch',
        'kernel-source',
        'binutils',
        'glibc-devel',
      ]
    }
    default: {
      fail("${::operatingsystem} not supported by ${::module_name}")
    }
  }
}
