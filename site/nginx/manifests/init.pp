class nginx {
  
  File {
    owner =>  'root',
    group =>  'root',
    mode  =>  '0664',
    ensure  =>  file,
  }
  
  $docroot  = '/var/www'
  $confdir  = '/etc/nginx'

  package { 'nginx':
    ensure  => present,
  }
  
  file { [$docroot,$confdir,"${confdir}/conf.d" ]:
    ensure  =>  directory,
  }
  
  file { "${confdir}/nginx.conf":
    source  => 'puppet:///modules/nginx/nginx.conf',
    require  =>  Package['nginx'],
  }
  
  file { "${confdir}/conf.d/default.conf":
    source  =>  'puppet:///modules/nginx/default.conf',
    require  =>  Package['nginx'],
  }
  
  file  { "${docroot}/index.html":
    source  =>  'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure  =>  running,
    enable =>  true,
    subscribe => File["${confdir}/nginx.conf","${confdir}/conf.d/default.conf"],
  }

}
