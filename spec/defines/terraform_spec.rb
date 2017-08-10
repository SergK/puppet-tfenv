require 'spec_helper'

describe 'tfenv::terraform', type: :define do
  let :pre_condition do
    "class { '::tfenv': install_dir => '/opt/tfenv2'}"
  end
  context 'check with installing version 0.10.0' do
    let(:title) { '0.10.0' }

    it {
      is_expected.to contain_vcsrepo('/opt/tfenv2').with(
        'ensure'   => 'present',
        'provider' => 'git',
        'revision' => 'v0.5.2',
        'source'   => 'https://github.com/kamatama41/tfenv',
        'user'     => 'jenkins',
        'group'    => 'jenkins'
      )
    }

    it {
      is_expected.to contain_file('/opt/tfenv2')
        .that_comes_before('Vcsrepo[/opt/tfenv2]')
    }

    it { is_expected.to have_exec_resource_count(1) }

    it {
      is_expected.to contain_exec('Install terraform version 0.10.0').with(
        'command' => 'tfenv install 0.10.0',
        'path'    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        'unless'  => 'test -d /opt/tfenv2/versions/0.10.0'
      )
    }
  end
end
