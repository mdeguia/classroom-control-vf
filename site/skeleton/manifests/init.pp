class skeleton {
  file { '/etc/skel':
    ensure  =>  directory,
    }
  
  file { '/etc/skel/.bashrc':
    ensure  =>  file,
    mode    =>  '0744',
    source  =>  'puppet:///modules/skeleton/bashrc',
    }
}
