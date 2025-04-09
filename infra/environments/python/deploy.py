import boto3
from botocore.exceptions import ClientError
import time

# Initialize RDS client
rds_client = boto3.client('rds', region_name='us-east-1')

# RDS instance parameters
db_instance_identifier = 'my-postgresql-instance'
db_name = 'mydatabase'
db_user = 'dbadmin'  # 'admin' is a reserved word in PostgreSQL, so use something else
db_password = 'mysecurepassword'
allocated_storage = 20 
instance_class = 'db.t3.micro'

try:
    # Create the RDS instance
    response = rds_client.create_db_instance(
        DBInstanceIdentifier=db_instance_identifier,
        AllocatedStorage=allocated_storage,
        DBName=db_name,
        Engine='postgres',
        EngineVersion='13',  # Updated to a valid version (e.g., 13)
        MasterUsername=db_user,
        MasterUserPassword=db_password,
        DBInstanceClass=instance_class,
        MultiAZ=False,
        PubliclyAccessible=True,  # Adjust based on your needs
        StorageType='gp2',
    )
    
    # Wait for the DB instance to be available
    print(f"Waiting for the RDS instance {db_instance_identifier} to be created...")
    waiter = rds_client.get_waiter('db_instance_available')
    waiter.wait(DBInstanceIdentifier=db_instance_identifier)
    
    # Once available, retrieve the endpoint
    db_instance = rds_client.describe_db_instances(DBInstanceIdentifier=db_instance_identifier)
    if db_instance['DBInstances']:
        endpoint = db_instance['DBInstances'][0]['Endpoint']['Address']
        print("RDS instance created successfully. Endpoint:", endpoint)

except ClientError as e:
    print("Error creating RDS instance:", e)
