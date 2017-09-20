require 'spec_helper'
describe 'rook' do
  context 'with default values for all parameters' do
    it { should contain_class('rook') }
  end
end
