require 'spec_helper_acceptance'

describe 'tfenv class' do
  context 'default class inclusion' do
    it 'should work with no errors' do
      pp = <<-EOS
        $packages = [
          'git',
          'unzip'
        ]

        package { $packages:
          ensure  => installed
        }

        class { '::tfenv': }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/tfenv/.git') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'jenkins' }
    end

    describe file('/opt/tfenv/.git/HEAD') do
      it { is_expected.to contain 'ad823dbbad78f442b29a686812601bafa48e27c1' }
    end
  end
end

describe 'tfenv class with custom settings' do
  context 'do not create group but manage user' do
    it 'should work with no errors' do
      shell('rm -rf /opt/tfenv')
      shell('rm -rf /usr/local/bin/t*')
      pp = <<-EOS
        class { '::tfenv':
          manage_user  => true,
          manage_group => false,
          tfenv_user   => jenkins,
          tfenv_group  => root,
        }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
      # test terraform installation version 0.10.0
      shell('tfenv install 0.10.0')
    end

    describe file('/opt/tfenv/.git') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'jenkins' }
    end

    describe file('/opt/tfenv/.git/HEAD') do
      it { is_expected.to contain 'ad823dbbad78f442b29a686812601bafa48e27c1' }
    end
    describe file('/opt/tfenv/version') do
      it { is_expected.to contain '0.10.0' }
    end
  end
end

describe 'run tests for tfenv' do
  context 'test tfenv functionality' do
    it 'should install version 0.8.8' do
      shell('cd /tmp/terraform-0.8.8; tfenv install')
    end

    tf_list = "0.10.0\n0.8.8\n"

    it 'should list all installed terraform versions' do
      expect(shell('tfenv list').stdout).to eq(tf_list)
    end

    describe file('/opt/tfenv/version') do
      it { is_expected.to contain '0.8.8' }
    end
  end
end
