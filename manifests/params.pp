# @summary It sets variables according to platform
#
# Sets variables according to platform
#
# @api private
#
class virtualbox::params {

  case $::osfamily {
    'Debian': {
      $package_name = 'virtualbox'
      $manage_repo = true
      $vboxdrv_dependencies = [
        'dkms',
        "linux-headers-${facts['kernelrelease']}",
        'build-essential',
      ]

    }
    'RedHat': {
      $manage_repo = true
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
        'glibc-devel',
      ]
    }
    'Suse': {
      warning('Careful! Support for SuSE is experimental at best.')
      $manage_repo = true
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
      fail("${facts['operatingsystem']} not supported")
    }
  }
}
