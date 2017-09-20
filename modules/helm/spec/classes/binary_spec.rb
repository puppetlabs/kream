require 'spec_helper'

describe 'helm::binary', :type => :class do

  let(:facts) { { :architecture => 'amd64' } }

  context 'with install_path => /usr/bin and version => 2.5.1 values for all parameters' do
    let(:params) { {
                    'install_path' => '/usr/bin',
                    'version' => '2.5.1',
                 } }
    it do
      is_expected.to compile
      is_expected.to contain_archive('helm').with({
        'path' => '/tmp/helm-v2.5.1-linux-amd64.tar.gz',
        'source' => 'https://kubernetes-helm.storage.googleapis.com/helm-v2.5.1-linux-amd64.tar.gz',
        'extract_command' => 'tar xfz %s linux-amd64/helm --strip-components=1 -O > /usr/bin/helm-2.5.1',
        'extract' => 'true',
        'extract_path' => '/usr/bin',
        'creates' => '/usr/bin/helm-2.5.1',
        'cleanup' => 'true'
      })
      is_expected.to contain_file('/usr/bin/helm-2.5.1').with({ :owner => 'root', :mode => '0755', :require => 'Archive[helm]'})
      is_expected.to contain_file('/usr/bin/helm').with({ :ensure => 'link', :target => '/usr/bin/helm-2.5.1', :require => 'File[/usr/bin/helm-2.5.1]'})
    end
  end
end
