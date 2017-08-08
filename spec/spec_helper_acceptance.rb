require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

ENV['PUPPET_INSTALL_TYPE']='agent'
ENV['PUPPET_INSTALL_VERSION']='1.8.0'

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['RedHat','Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      on host, "mkdir -p /tmp/terraform-0.8.8"
      on host, "echo 0.8.8 > /tmp/terraform-0.8.8/.terraform-version"
    end

  end
end
