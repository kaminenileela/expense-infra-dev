SG Rules
------------


![alt text](02-sg/sg-rules.svg)


Expense Architecture
---------------------


![alt text](expense-infra-dev.drawio.svg)


There are 2 kinds of architecture as per understanding
1. Project architecture
2. Application architecture

Project architecture is rarely changed like security group (base of house)
expense is project in that,
frontend and backend are stateless components ---> they change for every deployment
database is stateful component---> mostly will be same

Application architecture is subjected to frequent change like security group rule (designing of house)
--> EC2, AMI, Launch template


* In this project we are using ansible pull based architecture, so we no need ansible server

userdata
---------------------
once ec2 instance created, aws will run userdata script.

1. we have to login inside instance and check the logs,
2. once userdata is changed, AWS will not update EC2
	delete EC2 manually and run terrafrom again

null_resource
-------------

null resource will not create any infra structure but this is useful to run local-exec, remote-exec and file provisioners.

Ansible pull
-----------
Install ansible in remote node
ansible-pull -i <inventory> -U <ansible-playbook-git-url> <yaml-name> -e var=value -->we can run in remote node.
In pull --> inventory defaults to localhost.

Steps to configure backend:
-------------------------

Backend
--------------------
1. create EC2 instance first
2. connect to the server using null resource and remote exec.
3. copy the script into instance.
4. run ansible configuration
5. stop the server
6. take AMI
7. delete the server
	aws configure
	aws
8. target group creation
9. launch template
10. autoscaling and policy
11. listener rule
	
match the declared configuration with actual configuration

actual configuration of server
server state --> terminated
declared state --> create the server


terraform target resource:
--------------------------

terraform plan -target=aws_autoscaling_group.backend ---> to specifically run only a particular resource use target.





