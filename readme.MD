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

null_resource
-------------

null resource will not create any infra structure but this is useful to run local-exec, remote-exec and file provisioners.


