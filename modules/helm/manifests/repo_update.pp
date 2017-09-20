define helm::repo_update (
  $debug = false,
  $env = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $path = undef,
  $tiller_namespace = undef,
  $update = true,
){

  include helm::params

  if $update {
    $helm_repo_update_flags = helm_repo_update_flags({
      debug => $debug,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
      update => $update,
    })
  }

  $exec_update = "helm repo ${helm_repo_update_flags}"

  exec { 'helm repo update':
    command     => $exec_update,
    environment => $env,
    path        => $path,
    timeout     => 0,
  }
}