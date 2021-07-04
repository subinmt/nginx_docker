# Nginx Docker Container Build and Deployment

## Prerequisites

Here I am baking the AMI with the following applications.

1. awscli
2. git 
3. Docker
4. Jenkins

## Enabling Non-root Users to Run Docker Commands

This is a CICD pipeline job, so the jenkins job running under the "jenkins" user. So we need to grant necessery access to the jenkins user using the following commands.

Create the docker group:

```
groupadd docker
```

Restart the docker service:
```
service docker restart
```

The UNIX socket /var/run/docker.sock is now readable and writable by members of the docker group.

Add the users that should have Docker access to the docker group:

```
usermod -a -G docker jenkins
```

## Terraform Setup

You can use terraform folder created here. This will create the resources for nginx-docker. This module will attach existing IAM role to the ec2 instance.

Run terraform:
```
terraform init
terraform plan 
terraform apply 
```

## Clean up

Run terraform:
```
terraform destroy 
```

## Jenkins Configurations

Once you deployed the ec2 instance using the terraform script attached here, you need to configure your  jenkins. Jenkins already installed on the AMI. So please configure your user account and password in jenkins and also configure the git-credentails from the Managed user section.

Next you need to create select a create new job, for that please follow the below steps:

1. From Dashboard, open New item.
2. Enter the item name and select "Pipeline" and press Ok button.
3. Under the Advanced Project Option, copy and paste your jenkinsfile(pipeline) to pipeline section and save.(if you want to use jenkinsfile from github, thats also possible) 

## Run Pipeline

Once the jenkins configurations done, you are able to run the jenkins job. So that you need to input your branch name which contains your Dockerfile. 

Note: Dockerfile attached on the above.

## Outputs

Please find the screenshots of Jenkins pipeline and nginx welcome page.!

### Jenkins Pipeline:

![alt text](https://github.com/subinmt/nginx_docker/blob/main/jenkins.png?raw=true)

### Nginx Welcome Page

![alt text](https://github.com/subinmt/nginx_docker/blob/main/nginx.png?raw=true)


