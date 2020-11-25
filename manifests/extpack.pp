# @summary  This class (un)installs Oracle's VirtualBox extension pack.
#
# @param source
#   Download extension pack from the given URL. Required string.
# @param ensure
#   Set to 'present' to install extension pack. Set to 'absent' to uninstall.
#   Defaults to 'present'
# @param verify_checksum
#   Whether to verify the checksum of the downloaded file. Optional boolean.
#   Defaults to true.
# @param checksum_string
#   If $verify_checksum is true, this is the checksum to use to validate the
#   downloaded file against.
# @param checksum_type
#   If $verify_checksum is true, this is the algorithm to use to validate the
#   checksum. Can be md5, sha1, sha224, sha256, sha384, or sha512. Defaults to
#   'md5'
# @param extpack_path
#   This is the path where VirtualBox looks for extension packs. Defaults to
#   '/usr/lib/virtualbox/ExtensionPacks'
define virtualbox::extpack (
  String $source,
  Enum['present', 'absent'] $ensure                                                       = 'present',
  Boolean $verify_checksum                                                                = true,
  Optional[String] $checksum_string                                                       = undef,
  Enum['md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512'] $checksum_type              = 'md5',
  Stdlib::Absolutepath $extpack_path                                                      = '/usr/lib/virtualbox/ExtensionPacks',
) {
  if $verify_checksum {
    $_checksum_type   = $checksum_type
    $_checksum_string = $checksum_string
  } else {
    $_checksum_type   = undef
    $_checksum_string = undef
  }

  $dest = "${extpack_path}/${name}"

  archive { "/usr/src/${name}.tgz":
    ensure          => $ensure,
    source          => $source,
    checksum        => $_checksum_string,
    checksum_type   => $_checksum_type,
    checksum_verify => $verify_checksum,
    extract         => false,
    require         => Class['virtualbox'],
  }

  case $ensure {
    'present': {
      exec { "${name} unpack":
        command => "mkdir -p ${dest} && tar --no-same-owner --no-same-permissions -xzf /usr/src/${name}.tgz -C ${dest}",
        creates => $dest,
        timeout => 120,
        path    => $::path,
        require => Archive["/usr/src/${name}.tgz"],
      }
    }
    'absent': {
      file { $dest:
        ensure  => absent,
        recurse => true,
        purge   => true,
        force   => true,
      }
    }
    default: { fail('Unknown value for $ensure.') }
  }
}
