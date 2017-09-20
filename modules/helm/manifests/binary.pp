class helm::binary (
  $version = $helm::version,
  $install_path = $helm::install_path,
){

  case $::architecture {
    'amd64': {
      $arch = 'amd64'
    }
    'i386': {
      $arch = '386'
    }
    default: {
      fail("${::architecture} is not supported")
    }
  }

  $archive = "helm-v${version}-linux-${arch}.tar.gz"

  archive { 'helm':
    path            => "/tmp/${archive}",
    source          => "https://kubernetes-helm.storage.googleapis.com/${archive}",
    extract_command => "tar xfz %s linux-${arch}/helm --strip-components=1 -O > ${install_path}/helm-${version}",
    extract         => true,
    extract_path    => $install_path,
    creates         => "${install_path}/helm-${version}",
    cleanup         => true,
  }

  file { "${install_path}/helm-${version}" :
    owner   => 'root',
    mode    => '0755',
    require => Archive['helm']
  }

  file { "${install_path}/helm":
    ensure  => link,
    target  => "${install_path}/helm-${version}",
    require => File["${install_path}/helm-${version}"],
  }
}