require 'spec_helper'

describe 'helm::config', :type => :class do

  context 'with default values for all parameters' do
    let(:params) { {
                    'init' => true,
                    'service_account' => 'tiller',
                    'tiller_namespace' => 'kube-system',
                 } }
    it do
      is_expected.to compile
      is_expected.to contain_helm__helm_init('kube-master').with({
        'init' => 'true',
        'service_account' => 'tiller',
        'tiller_namespace' => 'kube-system',
      })
    end
  end
end