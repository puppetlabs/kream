# This class installs and configures the rook storgae class for block level storage

class rook::storage_class {

  $helm_files = ['rook-cluster.yaml', 'rook-storage.yaml']

  Exec {
    path        => ['/usr/bin', '/bin'],
    environment => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
    logoutput   => true,
    tries       => 10,
    try_sleep   => 30,
  }

  $helm_files.each | String $file | {
      file { "/tmp/${file}":
        ensure  => present,
        content => template("rook/${file}.erb"),
        }
    }

  exec { 'Create rook namespace':
    command => 'kubectl create namespace rook',
    unless  => 'kubectl get namespace | grep rook',
    before  => Exec['Create rook cluster'],

  }

  exec { 'Create rook cluster':
    command     => 'kubectl create -f rook-cluster.yaml',
    cwd         => '/tmp',
    subscribe   => File['/tmp/rook-cluster.yaml'],
    refreshonly => true,
    before      => Exec['Create storage class'],
    require     => File['/tmp/rook-cluster.yaml'],
  }

  exec { 'Create storage class':
    command     => 'kubectl create -f rook-storage.yaml',
    cwd         => '/tmp',
    subscribe   => File['/tmp/rook-storage.yaml'],
    refreshonly => true,
    require     => File['/tmp/rook-storage.yaml'],
  }
}
