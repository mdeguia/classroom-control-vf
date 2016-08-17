class nginx{

  package { 'nginx':
    ensure  => present,
  }
  
  file { '/var/www':
    ensure  =>  directory,
    requires  =>  Package['nginx'],
  }
  
  file { '/etc/nginx':
    ensure  =>  directory,
    requires  =>  Package['nginx'],
  }
  
  file { '/etc/nginx/nginx.conf':
    ensure  =>  file,
    source  => 'puppet:///modules/nginx/nginx.conf',
  }
  
  file { '/etc/nginx/conf.d':
    ensure  =>  directory,
  }
  
  file { '/etc/nginx/conf.d/default.conf':
    ensure  =>  file,
    source  =>  'puppet:///modules/nginx/default.conf',
  }
  
  file  { '/var/www/index.html':
    ensure  =>  file,
    source  =>  'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure  =>  running,
    enabled =>  true,
    subscribe => File['/etc/nginx/nginx.conf':],
  }

}
