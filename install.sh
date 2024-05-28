#!/bin/bash

INSTALL_DIR=/opt/install

yum update -y

mkdir -p $INSTALL_DIR

cd $INSTALL_DIR 


## ORACLE
curl -s "https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz" > jdk-21_linux-x64_bin.tar.gz 
tar -xzf jdk-21_linux-x64_bin.tar.gz

rm -rf /opt/jdk-21.0.3
mv jdk-21.0.3 /opt

export JAVA_HOME=/opt/jdk-21.0.3
echo 'export JAVA_HOME='$JAVA_HOME >> ~/.bashrc

## server.jar

mkdir -p /opt/minecraft/jars

curl -s https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar > /opt/minecraft/jars/server_1.20.6.jar
