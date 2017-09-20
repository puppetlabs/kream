# This class installs packages that rook needs 

class rook::packages {

  $rook_packages = [ 'ceph-common', 'ceph-fs-common']

  package { $rook_packages:
    ensure => present,
  }
}
