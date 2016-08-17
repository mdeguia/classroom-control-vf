class nginx {

  package { 'nginx':
    ensure  => present,
  }
  
  file { '/var/www':
    ensure  =>  directory,
  }
  
  file { '/etc/nginx/nginx.conf':
    ensure  =>  file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require  =>  Package['nginx'],
  }
  
  file { '/etc/nginx/conf.d':
    ensure  =>  directory,
  }
  
  file { '/etc/nginx/conf.d/default.conf':
    ensure  =>  file,
    source  =>  'puppet:///modules/nginx/default.conf',
    require  =>  Package['nginx'],
  }
  
  file  { '/var/www/index.html':
    ensure  =>  file,
    source  =>  'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure  =>  running,
    enable =>  true,
    subscribe => File['/etc/nginx/nginx.conf','/etc/nginx/conf.d/default.conf'],
  }

}
