#!/bin/bash

INSTALL_DIR=/opt/install

## UPGRADE SYSTEM
yum update -y
dnf upgrade --releasever=2023.4.20240513 -y


## BOOTSTRAP INSTALL
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR 


## DNS Startup Script

mkdir -p /root/bin
cat <<EOF > /root/bin/associate_dns
INSTANCE_IP=\`curl -s checkip.amazonaws.com\`

echo '{ "Comment": "Update the A record set", "Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "$DOMAIN_NAME", "Type": "A", "TTL": 60, "ResourceRecords": [ { "Value": "'\$INSTANCE_IP'" } ] } } ]}' > /tmp/a-record.json

aws route53 change-resource-record-sets --hosted-zone-id "$ROUTE53_ZONEID" --change-batch file:///tmp/a-record.json
EOF

chmod 700 /root/bin/associate_dns

/root/bin/associate_dns


## Shutdown cron

cat <<EOF > /root/bin/shutdown

sleep 14400

/sbin/shutdown -h now
EOF

chmod 700 /root/bin/shutdown 


cat <<EOF > /root/bin/crontab_entries.txt

@reboot  /root/bin/shutdown
@reboot  /root/bin/associate_dns

EOF

crontab <  /root/bin/crontab_entries.txt



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

rm -f /opt/minecraft/servers/zeldus/server.jar
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





## Startup

systemctl daemon-reload
systemctl enable zeldus.service
systemctl start zeldus.service

## PERMISSION CLEANUP

chown -R ec2-user:ec2-user /opt/minecraft /opt/jdk-21.0.3
