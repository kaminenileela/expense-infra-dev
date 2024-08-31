#!/bin/bash
component=$1
environment=$2
app_Version=$3
dnf install ansible -y
pip install botocore boto3
ansible-pull -i localhost, -U https://github.com/kaminenileela/expense-ansible-roles-tf.git main.yaml -e component=$component -e env=$environment -e appVersion=$app_Version
#appVersion(this name is what we gave in app-pre-req.yaml)=$appVersion (this is what we defined for $3)