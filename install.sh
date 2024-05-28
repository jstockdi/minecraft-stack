#!/bin/bash

INSTALL_DIR=/opt/install

yum update -y
dnf upgrade --releasever=2023.4.20240513 -y


mkdir -p $INSTALL_DIR

cd $INSTALL_DIR 


## ORACLE
curl -s "https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz" > jdk-21_linux-x64_bin.tar.gz 
tar -xzf jdk-21_linux-x64_bin.tar.gz

rm -rf /opt/jdk-21.0.3
mv jdk-21.0.3 /opt

export JAVA_HOME=/opt/jdk-21.0.3
echo 'export JAVA_HOME='$JAVA_HOME >> /home/ec2-user/.bashrc



## SERVER JAR

mkdir -p /opt/minecraft/jars

curl -s https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar > /opt/minecraft/jars/server_1.20.6.jar


## ZELDUS

mkdir -p /opt/minecraft/servers/zeldus
echo 'eula=true' > /opt/minecraft/servers/zeldus/eula.txt
cd /opt/minecraft/servers/zeldus && ln -s /opt/minecraft/jars/server_1.20.6.jar server.jar 


cat <<EOF > /etc/systemd/system/zeldus.service
[Unit]
Description=Zeldus Server
After=network.target

[Service]
User=ec2-user
Nice=5
KillMode=none
SuccessExitStatus=0 1
InaccessibleDirectories=/root /sys /srv /media -/lost+found
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft/servers/zeldus
ExecStart=$JAVA_HOME/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/bin/kill -SIGINT $MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zeldus.service
systemctl start zeldus.service







## PERMISSION CLEANUP

chown -R ec2-user:ec2-user /opt/minecraft /opt/jdk-21.0.3
