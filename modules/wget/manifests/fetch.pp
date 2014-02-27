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