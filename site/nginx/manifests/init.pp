class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $logdir   = $nginx::params::logdir,
) inherits nginx::params {

  
$user = $::osfamily ? {
 'redhat' => 'nginx',
 'debian' => 'www-data',
 'windows' => 'nobody',
 }

  
  File {
    owner =>  "$owner",
    group =>  "$group",
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
    content  => template('nginx/nginx.conf.erb'),
    require  =>  Package["$package"],
  }
  
  file { "${confdir}/conf.d/default.conf":
    content  =>  template('nginx/default.conf.erb'),
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

