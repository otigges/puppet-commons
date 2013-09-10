
class sonar() {
    
    $sonar_version = '3.7'
    $target_dir = "/opt/sonar"
    $sonar_home = "/opt/sonar/sonar-${sonar_version}"
    
    $jcbc_sonar_password = 'zfzt#+34'
    
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
        "$target_dir/scripts/init-mysql.sql":
            owner => "sonar", group => "sonar", mode => 400,
            content => template("sonar/init-mysql.sql.erb");
        "${sonar_home}/conf/sonar.properties":
            owner => "sonar", group => "sonar", mode => 400,
            content => template("sonar/sonar.properties.erb");                 
        "/etc/init.d/sonar":
            owner => "root", group => "root", mode => 755,
            content => template("sonar/sonar.sh.erb");            
    }
    
    exec {
        "unpack-sonar":
            command => "/usr/bin/unzip /tmp/sonar-${sonar_version}.zip -d ${target_dir} && chown -R sonar:sonar ${target_dir}",
            creates => "${target_dir}",
            require => User['sonar'],
    }
}

define wget::fetch($source,$destination) {
  
  package { 
    'wget': ensure => latest; 
  }
  
  if $http_proxy {
      exec { "wget-$name":
          command => "/usr/bin/wget --output-document=$destination $source",
          creates => "$destination",
          environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
      }
  } else {
      exec { "wget-$name":
          command => "/usr/bin/wget --output-document=$destination $source",
          creates => "$destination",
      }
  }
}

define sonar::download ($version){

    wget::fetch { 
        "sonar-${version}":
        source => "http://dist.sonar.codehaus.org/sonar-${version}.zip", 
        destination => "/tmp/sonar-${version}.zip";
    }
}