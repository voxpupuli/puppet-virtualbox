# == Class: virtualbox::kernel
#
# This is a private class meant to be called from virtualbox
# This class compiles and installs the VirtualBox kernel modules and
# dependencies.
#
class virtualbox::kernel (
  Boolean $manage_repo        = $virtualbox::manage_repo,
  Array $vboxdrv_dependencies = $virtualbox::vboxdrv_dependencies
) {

  ensure_packages($vboxdrv_dependencies)

  exec { '/etc/init.d/vboxdrv setup':
    unless      => '/sbin/lsmod | grep vboxdrv',
    environment => 'KERN_DIR=/usr/src/kernels/`uname -r`',
    require     => Package[$vboxdrv_dependencies],
  }

}
