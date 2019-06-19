#!/bin/sh
export AWS_DEFAULT_REGION=${region}
export AWS_PROFILE=${profile}

aws ec2 create-tags --resources ${resources} --tags Key=Name,Value=${value}
