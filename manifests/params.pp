# == Class virtualbox::params
#
# This class is meant to be called from virtualbox
# It sets variables according to platform
#
class virtualbox::params {
  $version = '4.3'
  $manage_kernel = true
  $manage_package = true
  $manage_repo = true
  $manage_epel = true
  $package_ensure = present

  case $::osfamily {
    'Debian': {
      $package_name = 'virtualbox'
      $vboxdrv_dependencies = [
        'dkms',
        "linux-headers-${::kernelrelease}",
        'build-essential',
      ]
    }
    'RedHat': {
      $package_name = 'VirtualBox'
      $vboxdrv_dependencies = [
        'gcc',
        'make',
        'patch',
        'dkms',
        'kernel-headers',
        'kernel-devel',
        'binutils',
        'glibc-headers',
        'glibc-devel'
      ]
    }
    'Suse': {
      warning('Careful! Support for SuSE is experimental at best.')

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
