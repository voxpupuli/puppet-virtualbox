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
#   If we should follow HTTP redirects. Ignored when using `puppet/archive`.
#   Defaults to false.
# [*extpack_path*]
#   This is the path where VirtualBox looks for extension packs. Defaults to
#   '/usr/lib/virtualbox/ExtensionPacks'
# [*archive_provider*]
#   This parameter is used to tell the module which `archive` module to expect.
#   This can be set to the Puppet Forge username of the developer of the
#   `archive` module you wish to use. If a falsey value is passed, this module
#   will try and determine the module author by using the `load_module_metadata`
#   function from Stdlib. This is the default behavior. Defaults to `false`.
#
define virtualbox::extpack (
  $source,
  $ensure           = present,
  $verify_checksum  = true,
  $checksum_string  = undef,
  $checksum_type    = 'md5',
  $follow_redirects = false,
  $extpack_path     = '/usr/lib/virtualbox/ExtensionPacks',
  $archive_provider = false,
) {

  validate_re($ensure, ['^present$', '^absent$'])
  validate_string($source)
  validate_absolute_path($extpack_path)
  validate_bool($follow_redirects)

  $_verify_checksum = str2bool($verify_checksum)

  if $_verify_checksum {
    validate_re($checksum_type, ['^md5', '^sha1', '^sha224', '^sha256', '^sha384', '^sha512'])
    validate_string($checksum_string)

    $_checksum_type   = $checksum_type
    $_checksum_string = $checksum_string
  } else {
    $_checksum_type   = undef
    $_checksum_string = undef
  }

  $dest = "${extpack_path}/${name}"

  if $archive_provider {
    validate_re($archive_provider, ['^puppet$', '^puppet-community$', '^voxpupuli$', '^camptocamp$'])
    $_provider = $archive_provider
  } else {
    $metadata = load_module_metadata('archive')
    $_provider = $metadata['source'] ? {
      /github\.com\/camptocamp/                   => 'camptocamp',
      /github\.com\/(puppet-community|voxpupuli)/ => 'voxpupuli',
    }
  }

  case $_provider {
    'camptocamp': {
      archive::download { "${name}.tgz":
        ensure           => $ensure,
        url              => $source,
        checksum         => $_verify_checksum,
        digest_type      => $_checksum_type,
        digest_string    => $_checksum_string,
        follow_redirects => $follow_redirects,
        require          => Class['virtualbox']
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
        checksum_verify => $_verify_checksum,
        extract         => false,
        require         => Class['virtualbox']
      }

      if $ensure =~ /^present$/ {
        Archive["/usr/src/${name}.tgz"] -> Exec["${name} unpack"]
      }
    }
    default: { fail('Unknown Archive module. Please install puppet/archive or camptocamp/archive.') }
  }

  case $ensure {
    present: {
      exec { "${name} unpack":
        command => "mkdir -p ${dest} && tar --no-same-owner --no-same-permissions -xzf /usr/src/${name}.tgz -C ${dest}",
        creates => $dest,
        timeout => 120,
        path    => $::path,
      }
    }
    absent: {
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
