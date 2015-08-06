# == Class: virtualbox::extpack
#
# This class (un)installs Oracle's VirtualBox extension pack.
#
# === Parameters
#
# [*ensure*]
#   Set to 'present' to install extension pack. Set to 'absent' to uninstall.
#   Defaults to 'present'
# [*source*]
#   Download extension pack from the given URL. Required string.
# [*verify_checksum*]
#   Whether to verify the checksum of the downloaded file. Optional boolean.
#   Defaults to true.
# [*checksum_string*]
#   If $verify_checksum is true, this is the checksum to use to validate the
#   downloaded file against.
# [*checksum_type*]
#   If $verify_checksum is true, this is the algorithm to use to validate the
#   checksum. Can be md5, sha1, sha224, sha256, sha384, or sha512. Defaults to
#   'md5'
# [*follow_redirects*]
#   If we should follow HTTP redirects. Defaults to false.
# [*extpack_path*]
#   This is the path where VirtualBox looks for extension packs. Defaults to
#   '/usr/lib/virtualbox/ExtensionPacks'
#
define virtualbox::extpack (
  $source,
  $ensure           = present,
  $checksum         = undef,
  $checksum_type    = 'md5',
  $extpack_path     = '/usr/lib/virtualbox/ExtensionPacks'
) {
  include archive

  validate_re($ensure, ['^present$', '^absent$'])
  validate_string($source)
  validate_absolute_path($extpack_path)
  

  validate_re($checksum_type, ['^md5', '^sha1', '^sha224', '^sha256', '^sha384', '^sha512'])
  validate_string($checksum)

  $_checksum_type   = $checksum_type
  $_checksum        = $checksum

  $dest = "${extpack_path}/${name}"
  
  archive { "${extpack_path}/${name}.tgz":
    ensure           => $ensure,
    source           => $source,
    checksum_type    => $_checksum_type,
    checksum         => $_checksum,
    require          => Class['virtualbox']
  }
  
  case $ensure {
    present: {
      exec { "${name} unpack":
        command => "mkdir -p ${dest} && tar --no-same-owner --no-same-permissions -xzf /usr/src/${name}.tgz -C ${dest}",
        creates => $dest,
        timeout => 120,
        path    => $::path,
        require => Archive["${extpack_path}/${name}.tgz"],
      }
    }
    absent: {
      file { "${extpack_path}/${name}":
        ensure  => absent,
        recurse => true,
        purge   => true,
        force   => true,
      }
    }
    default: { fail('Unknown value for $ensure.') }
  }

}
