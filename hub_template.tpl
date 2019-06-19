#!/bin/sh

AWS_DEFAULT_REGION=${region}
AWS_PROFILE=${account}

aws ec2 create-tags --resources ${resources} --tags Key=Name,Value=${value}
