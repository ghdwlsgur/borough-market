locals {
  aws_ecr_repository_name = var.AWS_RESOURCE_PREFIX
  aws_ecs_cluster_name    = "${var.AWS_RESOURCE_PREFIX}-cluster"
  aws_ecs_service_name    = "${var.AWS_RESOURCE_PREFIX}-service"
}

variable "AWS_REGION" {}
variable "EMAIL" {}
variable "AWS_RESOURCE_PREFIX" {}


variable "ECS_INSTANCE_TYPE" {
  default = "t2.medium"
}

variable "ECS_AMIS" {
  default = "ami-c8337dbb"
}

variable "AMIS" {
  default = "ami-0e592a261c043bc6a"
}




variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}



variable "SERVICE_ENABLE" {
  default = "0"
}

variable "VERSION" {
  default = "0"
}

