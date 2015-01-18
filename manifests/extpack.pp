# == Class: virtualbox::extpack
#
# This class (un)installs Oracle's VirtualBox extension pack.
#
# === Parameters
#
# [*ensure*]
#   Set to 'present' to install extension pack. Set to 'absent' to uninstall.
#   Defaults to 'present'
#
# [*version*]
#   Full version of the Extension Pack to install. E.g. '4.3.20r96996'. This
#   parameter is mandatory.
#
# [*source*]
#   Download extension pack from the given URL. If not specified download from
#   Oracle's official server.
#
class virtualbox::extpack (
  $ensure  = $virtualbox::params::extpack_ensure,
  $version = $virtualbox::params::extpack_version,
  $source  = $virtualbox::params::extpack_source
) inherits virtualbox::params {
  validate_string($ensure)
  validate_string($version)
  if $source {
    validate_string($source)
  }

  case $ensure {
    'present': {
      if $virtualbox::package_ensure == 'absent' {
        fail('Cannot install extension pack without installing VirtualBox')
      }
      if $version !~ /[^r]+r[^r]+/ {
        fail("'${version}' is not a valid version string!")
      }

      # install/upgrade if we do not have the requested version
      if $::virtualbox_extpack_version != $version {
        $ver = regsubst($version, '^([^r]+)r([^r]+)', '\1')
        $build = regsubst($version, '^([^r]+)r([^r]+)', '\2')
        $filename = "Oracle_VM_VirtualBox_Extension_Pack-${ver}-${build}.vbox-extpack"
        if $source {
          $url = $source
        } else {
          $url = "http://download.virtualbox.org/virtualbox/${ver}/${filename}"
        }
        $dl_dir = '/tmp'

        wget::fetch { 'download vbox extpack':
          source      => $url,
          destination => "${dl_dir}/${filename}",
        }

        exec { 'install vbox extpack':
          command => "VBoxManage extpack install --replace ${dl_dir}/${filename}",
          path    => '/usr/local/bin:/usr/bin:/bin',
          require => [
            Class['virtualbox::install'],
            Wget::Fetch['download vbox extpack'],
          ],
        }
      }
    }
    'absent': {
      if $::virtualbox_extpack_version {
        exec { 'uninstall vbox extpack':
          command => 'VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"',
          path    => '/usr/local/bin:/usr/bin:/bin',
        }

        # Make sure we process uninstall request after installing VirtualBox
        # (if VirtualBox will be installed during the same Puppet run) and
        # before removing VirtualBox (if VirtualBox will be uninstalled during
        # the same Puppet run)
        if defined(Class['virtualbox::install']) {
          if $virtualbox::package_ensure == 'absent' {
            Exec['uninstall vbox extpack'] -> Class['virtualbox::install']
          } else {
            Class['virtualbox::install'] -> Exec['uninstall vbox extpack']
          }
        }
      }
    }
    default: {
      fail("Invalid value for attribute 'ensure'")
    }
  }
}
