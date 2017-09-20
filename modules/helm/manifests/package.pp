define helm::package (
  $chart_name = undef,
  $chart_path = undef,
  $debug = false,
  $dependency_update = false,
  $destination = undef,
  $env = undef,
  $home = undef,
  $host = undef,
  $key = undef,
  $keystring = undef,
  $kube_context = undef,
  $path = undef,
  $save = true,
  $sign = false,
  $tiller_namespace = undef,
  $version = undef,
){

  include helm::params

  $helm_package_flags = helm_package_flags({
    chart_name => $chart_name,
    chart_path => $chart_path,
    debug => $debug,
    dependency_update => $dependency_update,
    destination => $destination,
    home => $home,
    host => $host,
    key => $key,
    keystring => $keystring,
    kube_context => $kube_context,
    save => $save,
    sign => $sign,
    tiller_namespace => $tiller_namespace,
    version => $version,
    })


  $exec_package = "helm package ${helm_package_flags}"

  exec { "helm package ${chart_name}":
    command     => $exec_package,
    environment => $env,
    path        => $path,
    timeout     => 0,
    creates     => "${destination}/${chart_name}-${version}.tgz"
  }
}