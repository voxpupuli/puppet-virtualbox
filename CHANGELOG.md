# Change log
All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
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

[unreleased]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.3.1...HEAD
[1.3.1]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.0.4...v1.1.0
[1.0.4]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/danzilio/danzilio-virtualbox/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/danzilio/danzilio-virtualbox/tree/v1.0.0
