class role::kubernetes::master {

  class {'kubernetes':
    controller => true,
  }

  include helm
  include rook

  contain kubernetes
  contain helm
  contain rook

  Class['kubernetes']
  -> Class['helm']
  -> Class['rook']

}
