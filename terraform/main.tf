terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-050dd51d996d9a69e"
  instance_type = "t3.medium"
  key_name = "sm-virginia"
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "AppServerInstance"
  }
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.jenkins_role.name
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name  = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}
