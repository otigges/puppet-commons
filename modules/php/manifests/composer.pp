class php::composer {
  
  require php
  
  file {
    '/opt/composer':
      ensure => directory,
      owner => root, group => users, mode => 0775;
  }
  
  exec {
    'install-php-composer':
      command => '/usr/bin/curl -s https://getcomposer.org/installer | php -- --install-dir=/opt/composer',
      creates => '/opt/composer/composer.phar',
      require => File['/opt/composer'];
  }
  
}