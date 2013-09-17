class php {

  package {
    ['php', 'php-mcrypt', 'php-pdo', 'php-mbstring', 'php-mysql'] :
      ensure => present,
      require => Exec['epel-installed'];
  }

  exec {
    'epel-installed':
      command => '/bin/rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
      unless => '/bin/rpm -q epel-release';
  }

}