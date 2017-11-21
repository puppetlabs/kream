# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Iterate through entries in YAML file
servers.each do |servers|

  config.vm.define servers["name"] do |srv|

    srv.vm.hostname = servers["name"]

    srv.vm.box = servers["box"]

    srv.vm.network "private_network", ip: servers["ip"]


   servers["forward_ports"].each do |port|
     srv.vm.network :forwarded_port, guest: port["guest"], host: port["host"], id: port["id"]
  end

   srv.vm.provider :virtualbox do |v|
        v.cpus = servers["cpu"]
        v.memory = servers["ram"]
  end

    srv.vm.synced_folder "./", "/home/vagrant/#{servers['name']}"

    servers["shell_commands"].each do |sh|
      srv.vm.provision "shell", inline: sh["shell"]
    end

    srv.vm.provision :puppet do |puppet|
        puppet.temp_dir = "/tmp"
        puppet.options = ['--modulepath=/tmp/modules', '--verbose', '--debug']
        puppet.hiera_config_path = "hiera.yaml"
        puppet.environment_path  = './'
        puppet.environment       = 'production'
        puppet.manifests_path    = 'manifests'
        puppet.manifest_file     = 'default.pp'
        end
      end
    end
  end
