#!/usr/bin/ruby env

require "socket"
$hostname = Socket.gethostname

forge 'http://forge.puppetlabs.com'


mod 'puppetlabs/stdlib'
mod 'puppetlabs/apt'
mod 'stahnma-epel'
mod 'puppet-archive'
mod 'puppetlabs/kubernetes'
mod 'puppetlabs/helm', :git => "https://github.com/puppetlabs/puppetlabs-helm.git"
