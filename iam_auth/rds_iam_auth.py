#!/usr/bin/python

import sys
import logging
import pymysql
import rds_config
import os
import boto3

rds_host, rds_port  = os.environ['DB_HOST'].split(":")
name = os.environ['DB_USERNAME']
# gather password from aws sdk ssm
ssm_name = os.environ['SSM_NAME']
db_name = rds_config.db_name

client = boto3.client('ssm')

get_ssm_value = client.get_parameter(Name=ssm_name, WithDecryption=True)
password = get_ssm_value['Parameter']['Value']

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    # lib requirement to connect to database
    conn = pymysql.connect(host=rds_host, user=name,
                           passwd=password, db=db_name, connect_timeout=5)
except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()

logger.info("SUCCESS: Connection to RDS mysql instance succeeded")
def lambda_handler(event, context):
    """
    This function creates read only user into mysql RDS instance
    """

    readonly_username = os.environ['RO_USER_NAME']
    admin_username = os.environ['ADMIN_USER_NAME']

    with conn.cursor() as cur:
        # creates read only user with rds plugin
        cur.execute("CREATE USER IF NOT EXISTS '" + readonly_username + "'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS'")
        cur.execute("GRANT SELECT ON *.* TO " + readonly_username)
        cur.execute("CREATE USER IF NOT EXISTS '" + admin_username + "'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS'")
        cur.execute("GRANT ALL PRIVILEGES ON `%`.* TO " + admin_username)
        cur.execute("FLUSH PRIVILEGES")
        # run query to post output to cloudwatch logs
        cur.execute("SELECT Host,User FROM user")
        for r in cur:
            print(r)
