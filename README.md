# Minecraft Stack

A stack for creating a high-powered Minecraft server:

* Start the instance via HTTP API
* 2h timer to turn off the instance and go outside
* Nightly backups
* Updates DNS on boot - no need for Elastic IPs or Dynamic DNS

How does it work

* Cloudformation file creates a stack
* Uses crontab to update DNS and shutdown server
* Install script loads default minecraft server and dependences (Designed to be re-run for upgrades)

# Pre-requisites

## Create stack user
Here are the permissions required to create the stack
```
aws iam create-user --user-name minecraft-stack
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AWSCloudFormationFullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AWSBackupFullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AWSLambda_FullAccess
aws iam attach-user-policy --user-name minecraft-stack --policy-arn arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator
```

## Create key pair
Generate a key pair to SSH into the machine to operate the server
```
aws ec2 create-key-pair --key-name MinecraftKey --query 'KeyMaterial' --output text > minecraft_key.pem
```


# Install

## Create stack

```
export ROUTE_53_ZONE=<Insert your route53 hosted zone>
export DOMAIN_NAME=<Insert your domain name>


aws cloudformation create-stack --stack-name MinecraftStack --template-body file://$PWD/stack.yaml --region us-east-1 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM   --parameters ParameterKey=Route53ZoneId,ParameterValue=$ROUTE_53_ZONE ParameterKey=DomainName,ParameterValue=$DOMAIN_NAME

aws cloudformation describe-stack-events --stack-name MinecraftStack
```




# Helpful tools

# Get public IP-address
```
./bin/public_ip.sh

```