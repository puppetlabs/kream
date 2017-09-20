define helm::chart (
  $ensure = present,
  $ca_file = undef,
  $cert_file = undef,
  $chart = undef,
  $devel = false,
  $dry_run = false,
  $env = undef,
  $key_file = undef,
  $key_ring = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $name_template = undef,
  $namespace = undef,
  $no_hooks = false,
  $path = undef,
  $purge = true,
  $replace = false,
  $repo = undef,
  $release_name = undef,
  $set = [],
  $timeout = undef,
  $tiller_namespace = 'kube-system',
  $tls = false,
  $tls_ca_cert = undef,
  $tls_cert = undef,
  $tls_key = undef,
  $tls_verify = false,
  $values = [],
  $verify = false,
  $version = undef,
  $wait = false,
){

  include helm::params

  if ($release_name == undef) {
    fail("\nYou must specify a name for the service with the release_name attribute \neg: release_name => 'mysql'")
  }

  if $ensure == present {
    $helm_install_flags = helm_install_flags({
      ensure => $ensure,
      ca_file =>$ca_file,
      cert_file => $cert_file,
      chart => $chart,
      devel => $devel,
      dry_run => $dry_run,
      key_file => $key_file,
      key_ring => $key_ring,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      name_template => $name_template,
      namespace => $namespace,
      no_hooks => $no_hooks,
      replace => $replace,
      repo => $repo,
      release_name => $release_name,
      set => $set,
      timeout => $timeout,
      tiller_namespace => $tiller_namespace,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
      values => $values,
      verify => $verify,
      version => $version,
      wait => $wait,
      })
    $exec = 'helm install'
    $exec_chart = "helm ${helm_install_flags}"
    $unless_chart = "helm ls --tiller-namespace ${tiller_namespace} | grep ${release_name}"
  }

  if $ensure == absent {
    $helm_delete_flags = helm_delete_flags({
      ensure => $ensure,
      dry_run => $dry_run,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      name_template => $name_template,
      namespace => $namespace,
      no_hooks => $no_hooks,
      purge => $purge,
      release_name => $release_name,
      timeout => $timeout,
      tiller_namespace => $tiller_namespace,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
      })
    $exec = 'helm delete'
    $exec_chart = "helm ${helm_delete_flags}"
    $unless_chart = "helm ls -q --tiller-namespace ${tiller_namespace} | awk '{if(\$1 == \"${release_name}\") exit 1}'"
  }

  exec { $exec:
    command     => $exec_chart,
    environment => $env,
    path        => $path,
    timeout     => 0,
    logoutput   => true,
    tries       => 10,
    try_sleep   => 10,
    unless      => $unless_chart,
  }
}
