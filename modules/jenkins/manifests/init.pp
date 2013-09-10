class jenkins {

  # TODO: automate
  #
  # wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  # rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  # yum install jenkins

  # TODO: activate http_proxy per yum repo: on for jenkins, off for demail-components/java7

  # TODO: Download sonar-ZIP from http://www.sonarsource.org/downloads/ and unpack to /opt/demail/sonar
  # Adapt /opt/demail/sonar/conf/sonar.properties
  # Add bind-address = 127.0.0.1 to /etc/my.cnf
  # Start sonar using: sudo -u sonar /opt/demail/sonar/bin/linux-x86-64/sonar.sh start
  # Better install as service as described by Mr. Smart: http://weblogs.java.net/blog/johnsmart/archive/2009/06/installing_sona.html

  # TODO: Install PhantomJS
  # Download from http://phantomjs.org/
  # Drop it into /usr/local/bin/phantomjs
  
  require jdk7
  
  package { 
    ['git','gcc', 'gcc-c++', 'rpm-build']: ensure => latest;
    'jenkins': 
      ensure => latest, 
      require => [
          File['/etc/yum.repos.d/jenkins.repo'],
          User['jenkins'],
          Exec['add-jenkins-repo-key'],          
        ];
  }

  group {
     'jenkins': ensure => present;
  }

  user { 'jenkins':
    gid => 'jenkins',
    managehome => true,
    home => '/var/lib/jenkins',
    shell => '/bin/bash',
    ensure => "present";
  }
  
  file {
    '/etc/yum.repos.d/jenkins.repo':
      source => 'puppet:///modules/jenkins/jenkins.repo',
      owner => root, group => users, mode => 0744;
    '/tmp/jenkins-ci.org.key':
      source => 'puppet:///modules/jenkins/jenkins-ci.org.key',
      owner => root, group => users, mode => 0744;  
  }
  
  exec {
    'add-jenkins-repo-key':
      command => '/bin/rpm --import /tmp/jenkins-ci.org.key',
      require => File['/tmp/jenkins-ci.org.key'],
  }
  
  service {
    'jenkins':
      ensure => running,
      provider => redhat,
      require => Package['jenkins'];
  }

}

