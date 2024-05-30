import boto3


###
##  NOTE:  Only used to test locally, then copied into stack.yaml
###
def handler(event, context):
  # Create EC2 client
  try:
    ec2_client = boto3.client('ec2')
    
  
    # Filter instances by tag
    filters = [{'Name': 'tag:Name', 'Values': ['MinecraftServer']}]
    reservations = ec2_client.describe_instances(Filters=filters)
    
    # Check if any instances found
    if not reservations['Reservations']:
      print("No EC2 instance found with the tag 'MinecraftServer'")
      return {'message': 'No Minecraft instance found'}
      

    # Extract instance ID from first reservation
    instance_id = reservations['Reservations'][0]['Instances'][0]['InstanceId']
    
    ec2_client.start_instances(InstanceIds=[instance_id])
    print(f"EC2 instance '{instance_id}' with Minecraft tag started successfully")
    return {
      'statusCode': 200,
      'body': f'Minecraft instance {instance_id} started'
    }
  
  except Exception as e:
    print(f"Error starting instance: {e}")
    return {'message': f'Error starting Minecraft instance: {e}'}


if __name__ == "__main__":
  handler(None,None)