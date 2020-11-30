import boto3
import os
import subprocess
from botocore.config import Config



if __name__ == '__main__':

    ACCESS_KEY = os.environ['ACCESS_KEY']
    SECRET_KEY = os.environ['SECRET_KEY']
    REGION = os.environ['REGION']
    print("-------------------------")
    print(ACCESS_KEY)
    print(SECRET_KEY)
    print("-------------------------")


    my_config = Config(
        region_name = 'eu-west-3',
        retries = {
            'max_attempts': 10,
            'mode': 'standard'
        }
    )
    client = boto3.client("ec2",
    #aws_access_key_id=ACCESS_KEY,
    #aws_secret_access_key=SECRET_KEY,
    config=my_config
    )
    controllerReserv = response = client.describe_instances(
        Filters=[
        {
            'Name': 'tag:Type',
            'Values': [
                'Controller',
            ]
        },
        ],
    )
    controller = controllerReserv['Reservations'][0]['Instances'][0]
    print(controller)
    controllerIp = controller["PublicIpAddress"]
    print(controllerIp)
    os.environ['clusterurl'] = controllerIp
    subprocess.call("./spark-script.sh", shell=True)
