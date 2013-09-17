define php::laravel(
  $document_root_dir='/var/www/laravel/public/',
  $storage_dir='/var/laravel/',
) {

  require database::mysql

  file {
    "${storage_dir}" :
      ensure => directory,
      owner => 'apache';
    ["${storage_dir}/cache", "${storage_dir}/logs", "${storage_dir}/meta", 
     "${storage_dir}/sessions", "${storage_dir}/views"] :
      ensure => directory,
      owner => 'apache', mode => 750;
    ['/opt/laravel', '/opt/laravel/db'] :
      ensure => directory;  
    '/opt/laravel/db/init-laravel-db.sql':
      source => 'puppet:///modules/php/init-laravel-db.sql';
  }

  exec {
    'laraval-db-initialized' :
      command => '/usr/bin/mysql < /opt/laravel/db/init-laravel-db.sql && touch /opt/laravel/db/db-creted.info',
      creates => '/opt/laravel/db/db-creted.info',
      require => File['/opt/laravel/db/init-laravel-db.sql'];
  }

}