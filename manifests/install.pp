# == Class: virtualbox::install
#
# This is a private class meant to be called from virtualbox
# This class installs the VirtualBox package. Based on the parameters it will
# also install a package repository.
#
class virtualbox::install (
  $version        = $virtualbox::version,
  $package_ensure = $virtualbox::package_ensure,
  $package_name   = $virtualbox::package_name,
  $manage_repo    = $virtualbox::manage_repo,
  $manage_package = $virtualbox::manage_package
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

        include apt

        apt::source { 'virtualbox':
          location          => 'http://download.virtualbox.org/virtualbox/debian',
          release           => $::lsbdistcodename,
          repos             => $apt_repos,
          required_packages => 'debian-keyring debian-archive-keyring',
          key               => '98AB5139',
          key_source        => 'https://www.virtualbox.org/download/oracle_vbox.asc',
          include_src       => false,
        }

        if $manage_package {
          Apt::Source['virtualbox'] -> Package['virtualbox']
        }
      }
    }
    'RedHat': {
      if $manage_repo {
        yumrepo { 'virtualbox':
          descr    => 'Oracle Linux / RHEL / CentOS-$releasever / $basearch - VirtualBox',
          baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
          gpgkey   => 'https://www.virtualbox.org/download/oracle_vbox.asc',
          gpgcheck => 1,
          enabled  => 1,
        }

        if $manage_package {
          Yumrepo['virtualbox'] -> Package['virtualbox']
        }
      }
    }
    default: { fail("${::osfamily} is not supported by this module.") }
  }

  if $manage_package {
    package { 'virtualbox':
      ensure => $package_ensure,
      name   => $validated_package_name,
    }
  }
}
