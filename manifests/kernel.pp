# == Class: virtualbox::kernel
#
# This is a private class meant to be called from virtualbox
# This class compiles and installs the VirtualBox kernel modules and
# dependencies.
#
class virtualbox::kernel (
  Boolean $manage_repo        = $virtualbox::manage_repo,
  Array $vboxdrv_dependencies = $virtualbox::vboxdrv_dependencies,
  String $vboxdrv_command     = $virtualbox::vboxdrv_command
) {

  ensure_packages($vboxdrv_dependencies)

  exec { 'vboxdrv':
    command     => "${vboxdrv_command} setup",
    unless      => '/sbin/lsmod | grep vboxdrv',
    environment => 'KERN_DIR=/usr/src/kernels/`uname -r`',
    require     => Package[$vboxdrv_dependencies],
  }

}
