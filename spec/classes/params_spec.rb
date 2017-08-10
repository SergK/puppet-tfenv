require 'spec_helper'

describe 'tfenv::params', type: :class do
  it { is_expected.to contain_class('tfenv::params') }
end
