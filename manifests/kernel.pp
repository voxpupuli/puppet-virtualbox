# @summary compiles and installs the VirtualBox kernel modules
#
# compiles and installs the VirtualBox kernel modules and dependencies.
#
# @param manage_repo
#   Should this module manage the package repository?
# @param vboxdrv_dependencies
#   Dependencies for building the VirtualBox kernel modules.
#
# @api private
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
    environment => [ "KERN_DIR=/lib/modules/${kernelrelease}/build" ],
    require     => Package[$vboxdrv_dependencies],
  }

}
