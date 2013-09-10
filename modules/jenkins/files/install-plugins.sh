#!/bin/bash

wget http://localhost:8080/jnlpJars/jenkins-cli.jar

java -jar jenkins-cli.jar -s http://localhost:8080 \
  install-plugin checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit

java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart