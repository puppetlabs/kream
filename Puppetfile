#!/usr/bin/ruby env

require "socket"
$hostname = Socket.gethostname

forge 'http://forge.puppetlabs.com'


mod 'puppetlabs/stdlib'
mod 'puppetlabs/apt'
mod 'stahnma-epel'
mod 'puppet-archive'
mod 'puppet-wget'
mod 'puppetlabs/kubernetes',:git => "https://github.com/puppetlabs/puppetlabs-kubernetes.git", :branch => "k8s_cert"
mod 'puppetlabs/helm'
mod 'puppetlabs/rook'
mod 'herculesteam-augeasproviders_sysctl'
mod 'herculesteam-augeasproviders_core'
mod 'camptocamp-kmod'
