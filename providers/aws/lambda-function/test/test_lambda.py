"""
Simple lambda
"""

import boto3

client = boto3.client('sts')
print("loading function")

def whoami_handler(event, context):
    print ('Hello from aws identity:' + client.get_caller_identity()['Arn'])
