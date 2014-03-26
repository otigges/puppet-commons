class database::mysql {

  package { 
    'mysql-server': 
      ensure => latest; 
  }

  file { 
    '/etc/my.cnf':
      content => template("database/my.cnf.erb");          
  }

  service { 'mysqld':
    ensure => running,
    enable => true,
    provider => 'redhat',
    subscribe => File["/etc/my.cnf"],
    require => Package["mysql-server"]
  }

}