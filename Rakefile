require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
  require 'puppet-strings/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.send("disable_140chars")
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.send('disable_class_parameter_defaults')
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

namespace :strings do
  doc_dir = File.dirname(__FILE__) + '/doc'
  git_uri = `git config --get remote.origin.url`.strip
  vendor_mods = File.dirname(__FILE__) + '/.modules'

  desc "Checkout the gh-pages branch for doc generation."
  task :checkout do
    unless Dir.exist?(doc_dir)
      Dir.mkdir(doc_dir)
      Dir.chdir(doc_dir) do
        system 'git init'
        system "git remote add origin #{git_uri}"
        system 'git pull'
        system 'git checkout -b gh-pages'
      end
    end
  end

  desc "Push new docs to GitHub."
  task :push do
    Dir.chdir(doc_dir) do
      system 'git add .'
      system "git commit -m 'Updating docs for latest build.'"
      system 'git push origin gh-pages -f'
    end
  end

  desc "Run checkout, generate, and push tasks."
  task :update => [
    :checkout,
    :'strings:generate',
    :push,
  ]
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :metadata_lint,
  :spec,
]
