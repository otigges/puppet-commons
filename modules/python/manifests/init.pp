class python() {
  
  package {
    ['python', 'python-pip', 'python-setuptools', 'python-sphinx'] :
      ensure => present
  }
  
}

