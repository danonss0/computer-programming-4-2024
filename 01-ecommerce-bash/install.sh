#!/bin/bash

#NAME=${NAME:-"Lukasz"}
NAME=$(whoami)

echo "Hello ${NAME}"

### CONFIGURATION

REPOSITORY="https://github.com/jkanclerz/computer-programming-4-2024"
APP_NAME=${APP_NAME:-"ecommerce"}
VERSION=main
TMP_DEST=/tmp/${APP_NAME}
OS_DEPENDENCIES="git mc cowsay tree"

DEST=/opt/${APP_NAME}
USERNAME=${APP_NAME}

### SYSTEM UPGRADE

dnf update && dnf upgrade

### INSTALL GIT AND OS DEPENDENCIES

dnf install ${OS_DEPENDENCIES} -y -q

### SYNC REPO

rm -rf ${TMP_DEST} || true
git clone ${REPOSITORY} -b ${VERSION} ${TMP_DEST}

dnf install -y -q java-17-amazon-corretto maven-local-amazon-corretto17 

### BUILD PACKAGE

cd ${TMP_DEST} && mvn package -DskipTests

mkdir -p ${DEST}
adduser ${USERNAME} || true

mv ${TMP_DEST}/target/*.jar ${DEST}/app.jar
chown -R ${USERNAME}:${USERNAME} ${DEST}


echo 'java -jar -Dserver.port=8080 /opt/ecommerce/app.jar'
