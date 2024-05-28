# Minecraft Stack

Better stack for creating a AWS EC2 Instance.

* Uses a more powerful instance for no lag while running multiple worlds
* Installed only in /opt via a `curl | sh` script
* Install script can be run for updates after creating
* During startup, updates Route 53 to avoid elastic IP fees
* Automatically shuts off after 120mins
* Takes a backup during shutdown
* HTTP request launches server

# TODO

* DNS work
* Shutdown work
* HTTP launcher


# Pre-requisites

## Create stack user

```
aws iam create-user --user-name minecraft-stack
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AWSCloudFormationFullAccess
```

## Create key pair
```
aws ec2 create-key-pair --key-name MinecraftKey --query 'KeyMaterial' --output text > minecraft_key.pem
```


# Install

## Create stack

```
aws cloudformation create-stack --stack-name MinecraftStack --template-body file://$PWD/stack.yaml --region us-east-1
aws cloudformation describe-stack-events --stack-name MinecraftStack
```




# Helpful tools

# Get public IP-address
```
./bin/public_ip.sh

```
