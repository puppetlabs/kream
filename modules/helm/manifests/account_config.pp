class helm::account_config (
  $env = $helm::env,
  $path = $helm::path,
  $service_account = $helm::service_account,
  $tiller_namespace = $helm::tiller_namespace,
){

  Exec {
    cwd         => '/etc/kubernetes',
    environment => $env,
    logoutput   => true,
    path        => $path,
  }

  file {'/etc/kubernetes/tiller-serviceaccount.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => "0644",
    content => template('helm/tiller-serviceaccount.yaml.erb'),
  }

  exec {'create service account':
    command     => 'kubectl create -f tiller-serviceaccount.yaml',
    subscribe   => File['/etc/kubernetes/tiller-serviceaccount.yaml'],
    refreshonly => true,
    require     => File['/etc/kubernetes/tiller-serviceaccount.yaml'],
  }

  file {'/etc/kubernetes/tiller-clusterrole.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('helm/tiller-clusterrole.yaml.erb'),
  }

  exec {'create cluster role':
    command     => 'kubectl create -f tiller-clusterrole.yaml',
    subscribe   => File['/etc/kubernetes/tiller-clusterrole.yaml'],
    refreshonly => true,
    require     => File['/etc/kubernetes/tiller-clusterrole.yaml'],
  }
}

