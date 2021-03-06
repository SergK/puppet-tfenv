require 'spec_helper'

describe 'tfenv', type: :class do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('tfenv') }
    it { is_expected.to contain_class('tfenv::params') }

    it {
      %w[git unzip].each do |fn|
        is_expected.to contain_package(fn).with('ensure' => 'present')
      end
    }
  end

  context 'with managing user' do
    it {
      is_expected.to contain_user('jenkins').with(
        'ensure'  => 'present',
        'comment' => 'User to run tfenv',
        'home'    => '/opt/tfenv',
        'shell'   => '/usr/sbin/nologin',
        'gid'     => 'jenkins',
        'before'  => 'File[/opt/tfenv]'
      )
    }

    it {
      is_expected.to contain_group('jenkins').with(
        'ensure' => 'present',
        'before' => 'File[/opt/tfenv]'
      )
    }
  end

  context 'cloning the repository' do
    it {
      is_expected.to contain_file('/opt/tfenv').with(
        'ensure'  => 'directory',
        'owner'   => 'jenkins',
        'group'   => 'jenkins',
        'mode'    => '0755',
        'require' => "\
[Package[git]{:name=>\"git\"}, \
Package[unzip]{:name=>\"unzip\"}]"
      ).that_comes_before('Vcsrepo[/opt/tfenv]')
    }
  end

  context 'creating required symlink' do
    it {
      is_expected.to contain_file('/usr/local/bin/tfenv').with(
        'ensure'  => 'link',
        'target'  => '/opt/tfenv/bin/tfenv',
        'require' => 'Vcsrepo[/opt/tfenv]'
      )
    }

    it {
      is_expected.to contain_file('/usr/local/bin/terraform').with(
        'ensure'  => 'link',
        'target'  => '/opt/tfenv/bin/terraform',
        'require' => 'Vcsrepo[/opt/tfenv]'
      )
    }

    it {
      is_expected.to contain_vcsrepo('/opt/tfenv').with(
        'ensure'   => 'present',
        'provider' => 'git',
        'revision' => 'v0.5.2',
        'source'   => 'https://github.com/kamatama41/tfenv',
        'user'     => 'jenkins',
        'group'    => 'jenkins'
      )
    }
  end

  context 'with installing default terraform version' do
    let(:params) { { default_terraform_version: '0.9.11' } }

    it {
      is_expected.to contain_tfenv__terraform('0.9.11')
    }

    it {
      is_expected.to contain_exec('Set default terraform version to 0.9.11')
        .with(
          'command'     => 'tfenv use 0.9.11',
          'path'        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
          'unless'      => 'grep 0.9.11 /opt/tfenv/version',
          'refreshonly' => 'true'
        )
    }
  end
end
