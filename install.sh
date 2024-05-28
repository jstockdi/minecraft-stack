#!/bin/bash

INSTALL_DIR=/opt/install

yum update -y

mkdir -p $INSTALL_DIR

cd $INSTALL_DIR 

curl "https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz" > jdk-21_linux-x64_bin.tar.gz 


