require 'spec_helper_acceptance'

describe 'tfenv class' do

  context 'default class inclusion' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        class { '::tfenv': }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("/opt/tfenv/.git") do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'jenkins' }
    end

    describe file("/opt/tfenv/.git/HEAD") do
      it { is_expected.to contain 'ad823dbbad78f442b29a686812601bafa48e27c1' }
    end
  end

  context 'do not create group but manage user' do
    it 'should work with no errors' do
      shell("rm -rf /opt/tfenv")
      shell("rm -rf /usr/local/bin/t*")
      pp = <<-EOS
        class { '::tfenv':
          manage_user  => true,
          manage_group => false,
          tfenv_user   => jenkins,
          tfenv_group  => root,
        }

      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("/opt/tfenv/.git") do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'jenkins' }
    end

    describe file("/opt/tfenv/.git/HEAD") do
      it { is_expected.to contain 'ad823dbbad78f442b29a686812601bafa48e27c1' }
    end
  end

end
