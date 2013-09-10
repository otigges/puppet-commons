class jdk7() {
    
    $jdk_version = '1.7.0'
    
    package { 
      "java-${jdk_version}-openjdk":
            ensure => latest; 
    }
    
}