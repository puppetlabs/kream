class helm::params {
  $env = [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
  $init = true
  $install_path = '/usr/bin'
  $path = [ '/bin','/usr/bin']
  $service_account = 'tiller'
  $tiller_namespace = 'kube-system'
  $version = '2.5.1'
}