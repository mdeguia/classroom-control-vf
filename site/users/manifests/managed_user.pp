define users::managed_user (
    $group  = $title,
) {
    file { "/home/${title}":
        ensure  =>  directory,
        owner   =>  $title,
        group   =>  $group,
    }
    file { "/home/${title}/.ssh":
        ensure  =>  directory,
        owner   =>  $title,
        group   =>  $group,
        mode    =>  '0700',
    }

    user { $title :
      ensure  =>  present,
    }
}
