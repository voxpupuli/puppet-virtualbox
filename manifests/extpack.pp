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
# @param follow_redirects
#   If we should follow HTTP redirects. Ignored when using `puppet/archive`.
#   Defaults to false.
# @param extpack_path
#   This is the path where VirtualBox looks for extension packs. Defaults to
#   '/usr/lib/virtualbox/ExtensionPacks'
# @param archive_provider
#   This param eter is used to tell the module which `archive` module to expect.
#   This can be set to the Puppet Forge username of the developer of the
#   `archive` module you wish to use. If a falsey value is passed, this module
#   will try and determine the module author by using the `load_module_metadata`
#   function from Stdlib. This is the default behavior. Defaults to `undef`.
#
define virtualbox::extpack (
  String $source,
  Enum['present', 'absent'] $ensure                                                       = 'present',
  Boolean $verify_checksum                                                                = true,
  Optional[String] $checksum_string                                                       = undef,
  Enum['md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512'] $checksum_type              = 'md5',
  Boolean $follow_redirects                                                               = false,
  Stdlib::Absolutepath $extpack_path                                                      = '/usr/lib/virtualbox/ExtensionPacks',
  Optional[Enum['puppet','puppet-community','voxpupuli','camptocamp']] $archive_provider  = undef,
) {
  if $verify_checksum {
    $_checksum_type   = $checksum_type
    $_checksum_string = $checksum_string
  } else {
    $_checksum_type   = undef
    $_checksum_string = undef
  }

  $dest = "${extpack_path}/${name}"

  if $archive_provider {
    $valid_archive_provider = $archive_provider
  } else {
    $metadata = load_module_metadata('archive')
    $valid_archive_provider = $metadata['source'] ? {
      /github\.com\/camptocamp/                   => 'camptocamp',
      /github\.com\/(puppet-community|voxpupuli)/ => 'voxpupuli',
    }
  }

  case $valid_archive_provider {
    'camptocamp': {

      warning 'Support for module camptocamp/archive is deprecated. Futur version of this module will only support puppet/archive.'
      archive::download { "${name}.tgz":
        ensure           => $ensure,
        url              => $source,
        checksum         => $verify_checksum,
        digest_type      => $_checksum_type,
        digest_string    => $_checksum_string,
        follow_redirects => $follow_redirects,
        require          => Class['virtualbox'],
      }

      if $ensure =~ /^present$/ {
        Archive::Download["${name}.tgz"] -> Exec["${name} unpack"]
      }
    }
    /^(voxpupuli|puppet-community|puppet)$/: {
      unless $follow_redirects {
        warning("The puppet/archive module does not support the \$follow_redirects parameter.")
      }

      archive { "/usr/src/${name}.tgz":
        ensure          => $ensure,
        source          => $source,
        checksum        => $_checksum_string,
        checksum_type   => $_checksum_type,
        checksum_verify => $verify_checksum,
        extract         => false,
        require         => Class['virtualbox'],
      }

      if $ensure =~ /^present$/ {
        Archive["/usr/src/${name}.tgz"] -> Exec["${name} unpack"]
      }
    }
    default: { fail('Unknown Archive module. Please install puppet/archive or camptocamp/archive.') }
  }

  case $ensure {
    'present': {
      exec { "${name} unpack":
        command => "mkdir -p ${dest} && tar --no-same-owner --no-same-permissions -xzf /usr/src/${name}.tgz -C ${dest}",
        creates => $dest,
        timeout => 120,
        path    => $::path,
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
