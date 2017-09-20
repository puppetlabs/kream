class helm::config (
  $env = $helm::env,
  $init = $helm::init,
  $path = $helm::path,
  $service_account = $helm::service_account,
  $tiller_namespace = $helm::tiller_namespace,
){

  helm::helm_init { 'kube-master':
    env              => $env,
    path             => $path,
    init             => $init,
    service_account  => $service_account,
    tiller_namespace => $tiller_namespace,
  }
}