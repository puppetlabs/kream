class role::kubernetes::controller {

  class {'kubernetes':
    controller => true,
  }
}