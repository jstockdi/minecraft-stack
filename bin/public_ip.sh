# Get the instance ID using jq
INSTANCE_ID=$(aws cloudformation describe-stack-resources --stack-name MinecraftStack | jq -r '.StackResources[] | select(.LogicalResourceId=="MinecraftServer") | .PhysicalResourceId')

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo "The public IP address of the Minecraft server is: $PUBLIC_IP"

