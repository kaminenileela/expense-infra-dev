#!/bin/bash
component=$1
environment=$2
# sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo yum update
sudo yum install epel-release
echo "installing ansible"
yum install ansible -y 
echo "installing ansible exit status: $?"
# echo "installing pip"
# pip3.9 install botocore boto3
# echo "installing pip exit status: $?"
echo "installing ansible-pull"
ansible-pull -i localhost, -U https://github.com/kaminenileela/expense-ansible-roles-tf.git main.yaml -e component=$component -e env=$environment
echo "installing ansible-pull exit status: $?"