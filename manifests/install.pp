# @summary installs the VirtualBox package
#
# This is a private class meant to be called from virtualbox
# This class installs the VirtualBox package. Based on the parameters it will
# also install a package repository.
#
# @param version The major version of the package to install.
# @param package_ensure
#   This gets passed to the package resource as the value of the 'ensure'
#   parameter. This can be used to specify a package version.
# @param package_name
#   The name of the package to install. This must be the full packge name when
#   not the default. When the default is in use, it gets compounded with the
#   major.minor components of the version number.
# @param manage_repo Should this module manage the package repository?
# @param repo_proxy proxy used by yum
# @param manage_package Should this module manage the package?
#
# @api private
#
class virtualbox::install (
  String $version               = $virtualbox::version,
  String $package_ensure        = $virtualbox::package_ensure,
  String $package_name          = $virtualbox::package_name,
  Boolean $manage_repo          = $virtualbox::manage_repo,
  Optional[String] $repo_proxy  = $virtualbox::repo_proxy,
  Boolean $manage_package       = $virtualbox::manage_package
) {

  if $package_name == $virtualbox::params::package_name {
    $validated_package_name = "${package_name}-${version}"
  } else {
    $validated_package_name = $package_name
  }

  case $facts['os']['family'] {
    'Debian': {
      if $manage_repo {

        include apt

        if $repo_proxy {
          warning('The $repo_proxy parameter is not implemented on Debian-like systems. Please use the $proxy parameter on the apt class. Ignoring.')
        }

        apt::source { 'virtualbox':
          architecture => $facts['os']['architecture'],
          location     => 'http://download.virtualbox.org/virtualbox/debian',
          repos        => 'contrib',
          key          => {
            'id'     => 'B9F8D658297AF3EFC18D5CDFA2F683C52980AECF',
            'source' => 'https://www.virtualbox.org/download/oracle_vbox_2016.asc',
          },
        }

        if $manage_package {
          Apt::Source['virtualbox'] -> Class['apt::update'] -> Package['virtualbox']
        }
      }
    }
    'RedHat': {
      if $manage_repo {
        $platform = $facts['os']['name'] ? {
          'Fedora' => 'fedora',
          default  => 'el',
        }

        yumrepo { 'virtualbox':
          descr    => 'Oracle Linux / RHEL / CentOS-$releasever / $basearch - VirtualBox',
          baseurl  => "http://download.virtualbox.org/virtualbox/rpm/${platform}/\$releasever/\$basearch",
          gpgkey   => 'https://www.virtualbox.org/download/oracle_vbox.asc',
          gpgcheck => 1,
          enabled  => 1,
          proxy    => $repo_proxy,
        }

        if $manage_package {
          Yumrepo['virtualbox'] -> Package['virtualbox']
        }
      }
    }
    'Suse': {
      case $facts['os']['name'] {
        'OpenSuSE': {
          if $manage_repo {
            if $facts['os']['release']['full'] !~ /^(12.3|11)/ {
              fail('Oracle only supports OpenSuSE 11 and 12.3! You need to manage your own repo.')
            }

            zypprepo { 'virtualbox':
              baseurl     => "http://download.virtualbox.org/virtualbox/rpm/opensuse/${facts['os']['release']['full']}",
              enabled     => 1,
              autorefresh => 1,
              name        => 'Oracle Virtual Box',
              gpgcheck    => 0,
            }
            if $manage_package {
              Zypprepo['virtualbox'] -> Package['virtualbox']
            }
          }
        }
        default: { fail("${facts['os']['family']}/${facts['os']['name']} is not supported.") }
      }
    }
    default: { fail("${facts['os']['family']} is not supported.") }
  }

  if $manage_package {
    $_install_status = $facts['virtualbox_version'] ? {
      Pattern["^${version}"] => 'already-installed',
      Pattern['^5']          => 'upgrade',
      default                => 'not-yet-installed',
    }

    if $_install_status == 'upgrade' {
      # The version returned by fact is complete, like 5.2.27r129424.
      # Bellow, we try to match only the firsts two digits, like 5.2.
      $_current_version = $facts['virtualbox_version'].match(/^[0-9][^0-9]{1}[0-9]{1}/)

      package { "${package_name}-${_current_version[0]}":
        ensure => absent,
      }

      Package["${package_name}-${_current_version[0]}"] -> Package['virtualbox']
    }
    package { 'virtualbox':
      ensure => $package_ensure,
      name   => $validated_package_name,
    }
  }
}
