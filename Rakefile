require 'github_changelog_generator/task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.since_tag = '0.0.1'
  config.future_release = '0.1.1'
  config.user = 'SergK'
  config.project = 'puppet-tfenv'
end
