require 'spec_helper_acceptance'

describe 'tfenv::terraform class' do
  terraform_versions = %w[0.9.10 0.9.9 0.9.8 0.9.7]
  context 'default terraform config' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { '::tfenv':
          install_dir => '/opt/tfenv2'
        }

        $terraform_versions = #{terraform_versions}

        ::tfenv::terraform { $terraform_versions: }

      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/tfenv2/.git') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'jenkins' }
    end

    context 'Ensure that we installed all the required terraform versions' do
      it 'should list all installed terraform versions' do
        expect(shell('tfenv list').stdout).to eq(terraform_versions
                                                .join("\n") + "\n")
      end
    end
  end
end
