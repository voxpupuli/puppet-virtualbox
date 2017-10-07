# == Class: virtualbox::install
#
# This is a private class meant to be called from virtualbox
# This class installs the VirtualBox package. Based on the parameters it will
# also install a package repository.
#
class virtualbox::install (
  String $version               = $virtualbox::version,
  String $package_ensure        = $virtualbox::package_ensure,
  String $package_name          = $virtualbox::package_name,
  Boolean $manage_repo          = $virtualbox::manage_repo,
  Optional[String] $repo_proxy  = $virtualbox::repo_proxy,
  Boolean $manage_package       = $virtualbox::manage_package
) {

  if $package_name == $::virtualbox::params::package_name {
    $validated_package_name = "${package_name}-${version}"
  } else {
    $validated_package_name = $package_name
  }

  case $::osfamily {
    'Debian': {
      if $manage_repo {
        $apt_repos = $::lsbdistcodename ? {
          /(lucid|squeeze)/ => 'contrib non-free',
          default           => 'contrib',
        }

        include ::apt

        if $repo_proxy {
          warning('The $repo_proxy parameter is not implemented on Debian-like systems. Please use the $proxy parameter on the apt class. Ignoring.')
        }

        case $::lsbdistcodename {
          /^(jessie|stretch|xenial)$/: {
            $apt_key_thumb  = 'B9F8D658297AF3EFC18D5CDFA2F683C52980AECF'
            $apt_key_source = 'https://www.virtualbox.org/download/oracle_vbox_2016.asc'
          }
          default: {
            $apt_key_thumb  = '7B0FAB3A13B907435925D9C954422A4B98AB5139'
            $apt_key_source = 'https://www.virtualbox.org/download/oracle_vbox.asc'
          }
        }

        apt::key { $apt_key_thumb:
          ensure => present,
          source => $apt_key_source,
        }

        apt::source { 'virtualbox':
          location => 'http://download.virtualbox.org/virtualbox/debian',
          release  => $::lsbdistcodename,
          repos    => $apt_repos,
          require  => Apt::Key[ $apt_key_thumb ],
        }

        if $manage_package {
          Apt::Source['virtualbox'] -> Class['apt::update'] -> Package['virtualbox']
        }
      }
    }
    'RedHat': {
      if $manage_repo {
        $platform = $::operatingsystem ? {
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
      case $::operatingsystem {
        'OpenSuSE': {
          if $manage_repo {
            if $::operatingsystemrelease !~ /^(12.3|11)/ {
              fail('Oracle only supports OpenSuSE 11 and 12.3! You need to manage your own repo.')
            }

            zypprepo { 'virtualbox':
              baseurl     => "http://download.virtualbox.org/virtualbox/rpm/opensuse/${::operatingsystemrelease}",
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
        default: { fail("${::osfamily}/${::operatingsystem} is not supported by ${::module_name}.") }
      }
    }
    default: { fail("${::osfamily} is not supported by ${::module_name}.") }
  }

  if $manage_package {
    package { 'virtualbox':
      ensure => $package_ensure,
      name   => $validated_package_name,
    }
  }
}
