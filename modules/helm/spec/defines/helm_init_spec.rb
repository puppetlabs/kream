require 'spec_helper'

describe 'helm::helm_init', :type => :define do
  let(:title) { 'helm init' }

  context 'with init => true and service_account => tiller ' do
  let(:params) { { 'service_account' => 'tiller' } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm init').with_command(/helm init --service-account 'tiller' --tiller-namespace 'kube-system'/)
    end
  end

  context 'with upgrade => true' do
  let(:params) { { 'upgrade' => 'true' } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm init').with_command(/helm init --tiller-namespace 'kube-system' --upgrade/)
    end
  end
end