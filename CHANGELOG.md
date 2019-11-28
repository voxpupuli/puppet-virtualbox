# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v4.0.0) (2019-11-28)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v3.1.0...v4.0.0)

**Breaking changes:**

- defaults to virtualbox 6.0 [\#101](https://github.com/voxpupuli/puppet-virtualbox/pull/101) ([Dan33l](https://github.com/Dan33l))

**Merged pull requests:**

- update REFERENCE.md [\#104](https://github.com/voxpupuli/puppet-virtualbox/pull/104) ([Dan33l](https://github.com/Dan33l))
- use structured facts via hash $facts [\#102](https://github.com/voxpupuli/puppet-virtualbox/pull/102) ([Dan33l](https://github.com/Dan33l))
- Simplify apt repository handling [\#100](https://github.com/voxpupuli/puppet-virtualbox/pull/100) ([ekohl](https://github.com/ekohl))

## [v3.1.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v3.1.0) (2019-10-15)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v3.0.0...v3.1.0)

**Merged pull requests:**

- allow puppetlabs-stdlib 6.x [\#96](https://github.com/voxpupuli/puppet-virtualbox/pull/96) ([Dan33l](https://github.com/Dan33l))
- use puppet strings [\#95](https://github.com/voxpupuli/puppet-virtualbox/pull/95) ([Dan33l](https://github.com/Dan33l))

## [v3.0.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v3.0.0) (2019-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v2.3.0...v3.0.0)

**Breaking changes:**

- modulesync 2.7.0 and drop puppet 4 [\#88](https://github.com/voxpupuli/puppet-virtualbox/pull/88) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support of Ubuntu Cosmic and Disco \(repo key\) [\#90](https://github.com/voxpupuli/puppet-virtualbox/pull/90) ([meskaya](https://github.com/meskaya))

**Merged pull requests:**

- Allow puppetlabs/apt 7.x [\#89](https://github.com/voxpupuli/puppet-virtualbox/pull/89) ([dhoppe](https://github.com/dhoppe))

## [v2.3.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v2.3.0) (2018-12-19)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v2.2.1...v2.3.0)

**Closed issues:**

- Missing repository key for Ubuntu 18.04 [\#82](https://github.com/voxpupuli/puppet-virtualbox/issues/82)
- Warning message regarding unsupported architecture [\#80](https://github.com/voxpupuli/puppet-virtualbox/issues/80)

**Merged pull requests:**

- Add bionic to the apt::key regexp to support Ubuntu 18.04 [\#83](https://github.com/voxpupuli/puppet-virtualbox/pull/83) ([meskaya](https://github.com/meskaya))
- Add node architecture to the apt repository [\#81](https://github.com/voxpupuli/puppet-virtualbox/pull/81) ([meskaya](https://github.com/meskaya))

## [v2.2.1](https://github.com/voxpupuli/puppet-virtualbox/tree/v2.2.1) (2018-10-21)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v2.2.0...v2.2.1)

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#78](https://github.com/voxpupuli/puppet-virtualbox/pull/78) ([bastelfreak](https://github.com/bastelfreak))

## [v2.2.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v2.2.0) (2018-09-09)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- manage upgrade for version 5.x [\#72](https://github.com/voxpupuli/puppet-virtualbox/pull/72) ([Dan33l](https://github.com/Dan33l))

**Closed issues:**

- upgrade virtualbox [\#21](https://github.com/voxpupuli/puppet-virtualbox/issues/21)

**Merged pull requests:**

- allow puppetlabs/apt 6.x [\#76](https://github.com/voxpupuli/puppet-virtualbox/pull/76) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x [\#73](https://github.com/voxpupuli/puppet-virtualbox/pull/73) ([bastelfreak](https://github.com/bastelfreak))
- acceptance tests updated , run with beaker 4 [\#71](https://github.com/voxpupuli/puppet-virtualbox/pull/71) ([Dan33l](https://github.com/Dan33l))
- Remove support for puppet lower than 4 [\#68](https://github.com/voxpupuli/puppet-virtualbox/pull/68) ([Dan33l](https://github.com/Dan33l))
- Remove docker nodesets [\#66](https://github.com/voxpupuli/puppet-virtualbox/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#64](https://github.com/voxpupuli/puppet-virtualbox/pull/64) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v2.1.0) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v2.0.0...v2.1.0)

**Merged pull requests:**

- bump puppet to latest supported version 4.10.0 [\#62](https://github.com/voxpupuli/puppet-virtualbox/pull/62) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v2.0.0) (2017-11-11)

[Full Changelog](https://github.com/voxpupuli/puppet-virtualbox/compare/v1.8.0...v2.0.0)

**Breaking changes:**

- Migrate to puppet 4 datatypes [\#51](https://github.com/voxpupuli/puppet-virtualbox/pull/51) ([kBite](https://github.com/kBite))

**Implemented enhancements:**

- Recognize Debian Stretch [\#54](https://github.com/voxpupuli/puppet-virtualbox/pull/54) ([hansmi](https://github.com/hansmi))

## [v1.8.0](https://github.com/voxpupuli/puppet-virtualbox/tree/v1.8.0) (2017-02-11)

This is the last release with Puppet3 support!
* Modulesync

## 2016-12-22 Release 1.7.3
- Rerelease of 1.7.2 which didn't make it to the forge

## 2016-12-22 Release 1.7.2
- Modulesync with latest Vox Pupuli defaults
- First Release in the Vox Pupuli namespace, this moduel got donated by danzilio

## [1.7.1] - 2016-07-19
### Fixed
- Fixed a typo in `extpack` that prevented proper detection of the `archive` module.
- Fixing missing APT keys for newer Debian/Ubuntu versions.
- Fixes typo in `spec/classes/virtualbox_spec.rb`

## [1.7.0] - 2016-04-07
### Added
- Added the ability to use either `camptocamp/archive` or `puppet/archive`

### Changed
- Changed the default VirtualBox version to `5.0`

### Fixed
- Fixed a resource ordering bug on Debian-like systems (Issue: [#25](https://github.com/danzilio/danzilio-virtualbox/issues/25), PR: [#26](https://github.com/danzilio/danzilio-virtualbox/pull/26))

## [1.6.0] - 2015-12-14
### Added
- Parameterized the `vboxdrv` command in `virtualbox::kernel`

## [1.5.0] - 2015-08-26
### Added
- Added repo_proxy parameter to the `virtualbox` and `virtualbox::install` classes. Currently only implemented on RedHat-like systems.

### Changed
- Changed the default Puppet version in `Gemfile` to ~> 4.2
- Changed Ruby versions in `.travis.yml` from '2.1.0' and '2.0.0' to '2.1' and '2.0' respectively so we're testing with the most recent patchlevel
- Added the Puppet 3.8 series to the test matrix in `.travis.yml`
- Changed the `apt::key` resource to use the 40-character signature. Closes #19

## [1.4.0] - 2015-07-01
### Deprecated
- Deprecated support for Puppet < 4.0.0.

### Changed
- Bump the puppetlabs/apt dependency to >=2.1.0 so we can have support for Puppet < 3.5.0 again.
- Changed the default behavior for Debian/Puppet >= 3.0.0 combinations to manage the virtualbox repository.
- Updated `rspec` syntax from `should` to `expect`.

### Removed
- Removed the warnings for Debian/Puppet < 3.5.0.

### Added
- Added provisional support for Fedora.
- Added warnings for Debian/Puppet < 3.0.0.

## [1.3.1] - 2015-04-26
### Changed
- Fixed CHANGELOG headings.

## [1.3.0] - 2015-04-26
### Changed
- Now depends on puppetlabs/apt >=2.0. This means that users of Puppet < 3.5.0 will need to manage their own repositories since puppetlabs/apt is only compatible with Puppet >= 3.5.0. This has necessitated a change in default behavior. Now, the default setting for `manage_repo` is false if the `puppetversion` fact is < 3.5.0. Unfortunately, I can't express this in the module dependencies in `metadata.json` so users will have to work around this.
- More meaningful error messages when an operating system is not supported.
- Changed the `rspec-puppet` upstream in `Gemfile` to pull from `rubygems.org` instead of GitHub.
- Bound the version requirement for `camptocamp/archive` < 1.0.0.
- Cleaned up the Beaker node sets.

### Added
- Now formally supports Puppet 4.0.
- Added a `manage_epel` parameter so you can now disable or enable the EPEL repo separately from the VirtualBox repo.
- Added CentOS 6.6 and 5.11 to the beaker nodesets. Updated the documentation to reflect this.
- Experimental support for OpenSuSE added. There are plenty of caveats here, so this is not officially supported.

### Removed
- Removed future parser tests from `.travis.yml`
- This module no longer manages the `debian-keyring` and `debian-archive-keyring` packages as part of the `apt::source` resource.

## [1.2.1] - 2015-02-07
### Changed
- Added the `strings` tasks to the `Rakefile` and made generated documentation available via [GitHub pages](http://danzilio.github.io/danzilio-virtualbox).
- Fixed some whitespace issues in `README.md`.
- Simplified the `.travis.yml` layout by moving the environment variables in the `include` section to one line.
- Added the `yard` gem to the `Gemfile` for generating documentation with Puppet Strings.

## [1.2.0] - 2015-01-31
### Changed
- Updated `README.md` to document `virtualbox::extpack`.
- Refactored the way facts are handled in `spec/classes/virtualbox_spec.rb`.
- Changed the default `PUPPET_VERSION` in `Gemfile` to `~> 3.7.0`.
- Use the flat-style badges in `README.md`.
- Renamed `spec/acceptance/class_spec.rb` to `spec/acceptance/virtualbox_spec.rb`.

### Added
- Added the `virtualbox::extpack` defined type to manage VirtualBox Extension Packs.
- Added acceptance tests for `virtualbox::extpack`.
- Added a dependency on `camptocamp/archive` for `virtualbox::extpack`.

## [1.1.0] - 2014-12-19
### Changed
- Added Puppet 3.7 to the test matrix in `travis.yml`.
- Added support for testing the future parser in `spec/spec_helper.rb`.
- Added future parser tests in `travis.yml`.
- Updated `README.md` to note the test matrix.
- Start using the new build environments in Travis.
- Pinned `rspec-puppet` to version 2.0.0 in `Gemfile`.

### Added
- Added support for CentOS 7. There were no code changes required to support this, but I added a CentOS 7 node to the `beaker` tests to validate CentOS 7 compatability.

## [1.0.4] - 2014-12-09
### Changed
- Update `README.md` to note all supported operating systems.
- Clean up `metadata.json` in response to the Forge quality ratings.

## [1.0.3] - 2014-10-21
### Changed
- Add the `json` and `metadata-json-lint` gems to `Gemfile`.
- Add `metadata-json-lint` rake task to `Rakefile` and incorporate it into the `test` task.
- Update the dependencies in `metadata.json` and cleanup lint in the metadata.
- Tweak the spacing in `spec/acceptance/class_spec.rb`.
- Add `nodesets` for Debian 6 & 7 and Ubuntu 10.04.
- Use the `install_puppet` helper for acceptance tests.

## [1.0.2] - 2014-10-15
### Changed
- Refactored the `virtualbox_version` fact to only execute if `/usr/bin/VBoxManage` exists.
- Refactor the acceptance tests to use new `its` syntax.

## [1.0.1] - 2014-10-14
### Changed
- Added the Forge badge to `README.md`.
- Deleted the `Vagrantfile`, not sure how this made it in here anyway.
- Added some tags to the `metadata.json` file.

## [1.0.0] - 2014-10-13
Initial Release


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
