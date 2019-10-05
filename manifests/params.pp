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
      fail("${::operatingsystem} not supported by ${::module_name}")
    }
  }
}
