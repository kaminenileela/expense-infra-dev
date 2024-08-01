#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
pip 3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/kaminenileela/expense-ansible-roles-tf.git main.yaml -e component=$component -e env=$environment