 define helm::helm_init (
  $init = true,
  $canary_image = false,
  $client_only = false,
  $debug = false,
  $dry_run = false,
  $env = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $local_repo_url = undef,
  $net_host = false,
  $path = undef,
  $service_account = undef,
  $skip_refresh = false,
  $stable_repo_url = undef,
  $tiller_image = undef,
  $tiller_namespace = 'kube-system',
  $tiller_tls = false,
  $tiller_tls_cert = undef,
  $tiller_tls_key = undef,
  $tiller_tls_verify = false,
  $tls_ca_cert = undef,
  $upgrade = false,
){

  include helm::params

  if $init {
    $helm_init_flags = helm_init_flags({
      init => $init,
      canary_image => $canary_image,
      client_only => $client_only,
      debug => $debug,
      dry_run => $dry_run,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      local_repo_url => $local_repo_url,
      net_host => $net_host,
      service_account => $service_account,
      skip_refresh => $skip_refresh,
      stable_repo_url => $stable_repo_url,
      tiller_image => $tiller_image,
      tiller_namespace => $tiller_namespace,
      tiller_tls => $tiller_tls,
      tiller_tls_cert => $tiller_tls_cert,
      tiller_tls_key => $tiller_tls_key,
      tls_ca_cert => $tls_ca_cert,
      upgrade => $upgrade,
    })
  }

  $exec_init = "helm ${helm_init_flags}"
  $unless_init = "kubectl get deployment --namespace=${tiller_namespace}  | grep 'tiller-deploy' "

  exec { 'helm init':
    command     => $exec_init,
    environment => $env,
    path        => $path,
    logoutput   => true,
    timeout     => 0,
    unless      => $unless_init,
  }
}