class apache {

  group {
    'apache' :
      ensure => present
  }
  
  user { 'apache' :
    gid => 'apache',
    ensure => present;
  }

  package { 'httpd' : 
    ensure => present
  }
  
  service {
    'httpd' : 
      ensure => running,
  }

}