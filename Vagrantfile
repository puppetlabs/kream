# Specify minimum Vagrant version and Vagrant API version
VAGRANTFILE_API_VERSION = '2'

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Iterate through entries in YAML file
  servers['servers'].each do |s|
    config.vm.define s['name'] do |srv|
      srv.vm.hostname = s['name']

      srv.vm.box = s['box']

      srv.vm.network 'private_network', ip: s['ip'], name: 'HostNetwork', virtualbox__inet: true

      s['forward_ports'].each do |port|
        srv.vm.network :forwarded_port, guest: port['guest'], host: port['host'], id: port['id']
      end

      srv.vm.provider :virtualbox do |v|
        v.cpus = s['cpu']
        v.memory = s['ram']
        v.customize ["modifyvm", :id, "--nic2", "hostonlynet", "--host-only-net2=HostNetwork"]
      end

      srv.vm.synced_folder './', '/home/vagrant/share', type: 'virtualbox'

      servers['global_shell_commands'].each do |sh|
        srv.vm.provision 'shell', inline: sh['shell']
      end

      s['shell_commands'].each do |sh|
        srv.vm.provision 'shell', inline: sh['shell']
      end

      srv.vm.provision :puppet do |puppet|
          puppet.temp_dir = '/tmp'
          puppet.options = ['--modulepath=/tmp/modules', '--verbose', '--debug']
          puppet.hiera_config_path = 'hiera.yaml'
          puppet.environment_path  = './'
          puppet.environment       = 'production'
          puppet.manifests_path    = 'manifests'
          puppet.manifest_file     = 'default.pp'
      end
    end
  end
end
