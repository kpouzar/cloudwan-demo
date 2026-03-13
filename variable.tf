
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
  default     = 2
}

variable "vpc_environment" {
  description = "type of VPCs"
  default     = ["dev", "prod"]
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
