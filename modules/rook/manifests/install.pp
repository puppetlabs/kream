# This class installs the Helm repo for rook and the rook chart

class rook::install {

  $env = [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
  $path = ['/usr/bin', '/bin']

  helm::repo { 'rook-alpha':
    ensure    => present,
    env       => $env,
    path      => $path,
    repo_name => 'rook-alpha',
    url       => 'http://charts.rook.io/alpha',
    before    => Helm::Chart['rook']
  }

  helm::chart { 'rook':
    ensure       => present,
    chart        => 'rook-alpha/rook',
    env          => $env,
    path         => $path,
    release_name => 'rook',
  }
}
