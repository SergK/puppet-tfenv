require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

ENV['PUPPET_INSTALL_TYPE']='agent'
ENV['PUPPET_INSTALL_VERSION']='1.8.0'

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['RedHat','Suse','windows','AIX','Solaris']
