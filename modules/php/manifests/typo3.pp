define php::typo3(
  $version
) {
  
  $url = "http://prdownloads.sourceforge.net/typo3/typo3_src-${version}.tar.gz?download"
  
  file {
    '/opt/typo3' :
      ensure => directory, 
      owner => apache, group => apache, mode => 0750
  }

   wget::fetch { 
     "typo3-${version}":
       source => $url, 
       destination => "/tmp/typo3-src-${version}.tar.gz";      
   }
   
   exec {
     "unpack-type3-${version}":
        command => "/bin/tar xzpvf /tmp/typo3-src-${version}.tar.gz -C /opt/typo3 && chown -R apache:apache /opt/typo3",
        creates => "/opt/typo3/typo3_src-${version}",
        require => [
          Wget::Fetch["typo3-${version}"],
          File['/opt/typo3']
        ]
   }
  
}