require 'spec_helper'

describe 'helm', :type => :class do

  let(:facts) { {
                  :kernel       => 'Linux',
                  :architecture => 'amd64'
              } }

  let(:params) { {
                  'env' => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                  'init' => true,
                  'install_path' => '/usr/bin',
                  'path' => [ '/bin','/usr/bin'],
                  'service_account' => 'tiller',
                  'tiller_namespace' => 'kube-system',
                  'version' => '2.5.1',
               } }

  context 'with sane default values for all parameters' do
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_class('helm')
      is_expected.to contain_class('helm::binary')
      is_expected.to contain_class('helm::account_config')
      is_expected.to contain_class('helm::config')
    end
  end
end
