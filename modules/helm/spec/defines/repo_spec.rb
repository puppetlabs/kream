require 'spec_helper'

describe 'helm::repo', :type => :define do
  let(:title) { 'helm repo' }

  context 'with ensure => present and repo_name => foo' do
    let(:params) { {
                    'ensure' => 'present',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'repo_name' => 'foo',
                    'url' => 'https://foo.com/bar'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo').with_command("helm repo add 'foo' 'https://foo.com/bar'")
    end
  end
  context 'with ensure => absent and repo_name => foo' do
    let(:params) { {
                    'ensure' => 'absent',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'repo_name' => 'foo'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo').with_command(/helm repo remove 'foo'/)
    end
  end
end

