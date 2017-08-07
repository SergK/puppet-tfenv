require 'spec_helper'
describe 'tfenv' do

  context 'with defaults for all parameters' do
    it { should contain_class('tfenv') }
  end
end
