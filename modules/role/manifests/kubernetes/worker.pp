class role::kubernetes::worker {

  class {'kubernetes':
    worker => true,
  }
}