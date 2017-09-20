require 'spec_helper'

describe 'helm::package', :type => :define do
  let(:title) { 'helm package' }

  context 'with chart_name => foo & chart_path => /tmp' do
  let(:params) { {
                  'chart_path' => '/tmp',
                  'chart_name' => 'foo'
               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm package foo').with_command("helm package --save '/tmp/foo'")
    end
  end
end

