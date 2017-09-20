require 'spec_helper'

describe 'helm::account_config', :type => :class do

  let(:params) { {
                  'env' => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                  'path' => [ '/bin','/usr/bin'],
               } }

  context 'with default values for all parameters' do
    it do
      is_expected.to compile
      is_expected.to contain_file('/etc/kubernetes/tiller-serviceaccount.yaml').with({ :ensure => 'file', :owner => 'root', :group => 'root', :mode => '0644' })
      is_expected.to contain_file('/etc/kubernetes/tiller-clusterrole.yaml').with({ :ensure => 'file', :owner => 'root', :group => 'root', :mode => '0644' })
      is_expected.to contain_exec('create service account').with({
        'command'     => 'kubectl create -f tiller-serviceaccount.yaml',
        'subscribe'   => 'File[/etc/kubernetes/tiller-serviceaccount.yaml]',
        'refreshonly' => 'true',
        'require'     => 'File[/etc/kubernetes/tiller-serviceaccount.yaml]',
      })
      is_expected.to contain_exec('create cluster role').with({
        'command'     => 'kubectl create -f tiller-clusterrole.yaml',
        'subscribe'   => 'File[/etc/kubernetes/tiller-clusterrole.yaml]',
        'refreshonly' => 'true',
        'require'     => 'File[/etc/kubernetes/tiller-clusterrole.yaml]',
      })
    end
  end
end