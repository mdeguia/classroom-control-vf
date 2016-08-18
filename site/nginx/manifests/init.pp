class nginx {
  
  case $::osfamily {
    'RedHat','Debian' : {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir = '/var/log/nginx'
    }
 
    'Windows' : {
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx'
      $logdir = 'C:/ProgramData/nginx/logs'
    }
    
 default : {
    notify { "This ${::osfamily} is not supported": },
    }
    
  }
  
$user = $::osfamily ? {
 'redhat' => 'nginx',
 'debian' => 'www-data',
 'windows' => 'nobody',
 }

  
  File {
    owner =>  '$owner',
    group =>  '$group',
    mode  =>  '0664',
    ensure  =>  file,
  }
  
  package { $package:
    ensure  => present,
  }
  
  file { [$docroot,$confdir,"${confdir}/conf.d" ]:
    ensure  =>  directory,
  }
  
  file { "${confdir}/nginx.conf":
    source  => template('nginx/nginx.conf.erb'),
    require  =>  Package["$package"],
  }
  
  file { "${confdir}/conf.d/default.conf":
    source  =>  template('nginx/default.conf.erb'),
    require  =>  Package["$package"],
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

