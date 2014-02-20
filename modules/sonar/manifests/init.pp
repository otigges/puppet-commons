
class sonar() {
    
    $sonar_version = '4.1.2'
    $target_dir = "/opt/sonar"
    $sonar_home = "/opt/sonar/sonarqube"
    
    $jcbc_sonar_password = 'zfzt#+34'
    
    $context = 'sonar'
    $target_host = '127.0.0.1'
    $target_port = '9000'
    $target_context = 'sonar'
    
    sonar::download { 'sonar-download': version => $sonar_version }
    
    require jdk7
    require database::mysql
    
    package { 
        'unzip': 
            ensure => latest; 
    }
    
    group { 'sonar' :
        ensure => present;        
    }
    
    user { 'sonar' :
        gid => 'sonar',
        managehome => true,
        ensure => present;
    }
    
    file { 
        "${target_dir}":
            owner => "sonar", group => "sonar", mode => 750,
            recurse => true,
            ensure => directory;
        "${target_dir}/scripts":
            owner => "sonar", group => "sonar", mode => 750,
            ensure => directory;
        "${target_dir}/scripts/init-mysql.sql":
            owner => "sonar", group => "sonar", mode => 400,
            content => template("sonar/init-mysql.sql.erb");
        "/etc/httpd/conf.d/sonar-vhost.conf":
            owner => "sonar", group => "sonar", mode => 644,
            content => template("sonar/sonar-vhost.conf.erb"),
            notify => Service['httpd'];
        "${sonar_home}" : 
            ensure => link,
            target => "/opt/sonar/sonarqube-${sonar_version}";
        "${sonar_home}/conf/sonar.properties":
            owner => "sonar", group => "sonar", mode => 400,
            content => template("sonar/sonar.properties.erb"),
            require => Exec['unpack-sonar'];                 
        "/etc/init.d/sonar":
            owner => "root", group => "root", mode => 755,
            content => template("sonar/sonar.sh.erb");            
    }
    
    exec {
        'unpack-sonar':
            command => "/usr/bin/unzip /tmp/sonar-${sonar_version}.zip -d ${target_dir} && chown -R sonar:sonar ${target_dir}",
            unless  => "/usr/bin/test -d ${sonar_home}",
            creates => $sonar_home,
            require => [File[$target_dir],User['sonar']];
        'init-db':
            command => "/usr/bin/mysql < ${target_dir}/scripts/init-mysql.sql && touch ${sonar_home}/mysql.init.status",
            creates => "${sonar_home}/mysql.init.status",
            require => [Service['mysqld'],File["${target_dir}/scripts/init-mysql.sql"]];
    }
    
    service {
      'sonar':
        ensure => running,
        require => [
          Exec['unpack-sonar', 'init-db'],
          File["${sonar_home}/conf/sonar.properties"]
        ]
    }
}

class sonar::php() {
  
  require sonar
  
  $version = '1.2'
  $url = "http://repository.codehaus.org/org/codehaus/sonar-plugins/php/sonar-php-plugin/${version}/sonar-php-plugin-${version}.jar"
  
  wget::fetch { "sonar-php-${version}":
      source => $url, 
      destination => "/opt/sonar/sonarqube/extensions/plugins/sonar-php-plugin-${version}.jar";      
  }
  
}

define sonar::download ($version){
    wget::fetch { 
        "sonar-${version}":
        source => "http://dist.sonar.codehaus.org/sonarqube-${version}.zip", 
        destination => "/tmp/sonar-${version}.zip";
    }
}

class wget() {

  package { 
    'wget': ensure => latest; 
  }
}

define wget::fetch($source,$destination) {
  
  require wget
  
  if $http_proxy {
      exec { "wget-$name":
          command => "/usr/bin/wget --output-document=$destination $source",
          creates => $destination,
          environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
      }
  } else {
      exec { "wget-$name":
          command => "/usr/bin/wget --output-document=$destination $source",
          creates => $destination,
      }
  }
}