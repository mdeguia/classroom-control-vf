define users::managed_user (
    $group  = $title,
) {
  file { "/home/${title}":
    ensure  =>  directory,
    owner   =>  $title,
  }
  
  user { $title :
    ensure  =>  present,
  }
}
