
##################################################
# General  variable 
##################################################


variable "project" {
  description = "Project"
  default     = "cloudwan-demo"
}

variable "owner" {
  description = "Owner"
  default     = "Karel Pouzar"
}

variable "aws_region1" {
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "aws_region2" {
  description = "AWS Region"
  default     = "eu-north-1"
}

##################################################
# VPC variable
##################################################

variable "vpc_amount" {
  description = "Amount of VPCs per region"
  default     = 6
}

variable "vpc_environment" {
  description = "type of VPCs"
  default     = ["test", "test", "prod", "prod", "hybrid", "hybrid"]
}

variable "attachment_policy_label" {
  description = "attachement CWAN label for routing policies"
  default     = ["labelTestRequest", "labelTestRequest", "labelProdRequest", "labelProdRequest"]
}

variable "subnet_amount" {
  description = "Amount of subnets per VPC"
  default     = 2
}

variable "vpc_cidr1" {
  description = "VPC Superblock"
  default     = "10.0.0.0/10"
}

variable "vpc_cidr2" {
  description = "VPC Superblock"
  default     = "10.64.0.0/10"
}

##################################################
# server
##################################################

variable "ami" {
  description = "AMI image id"
  default = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-arm64"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t4g.nano"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  default     = "cloudwan-demo-key"
}