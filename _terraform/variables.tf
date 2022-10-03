

variable "ECS_AMI" {
  default = "ami-0b41652f00b442576"
}

variable "INSTANCE_TYPE" {
  default = "t2.medium"
}

variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "AWS_RESOURCE_PREFIX" {
  default = "borough-market"
}

variable "EMAIL" {
  default = "redmax45@naver.com"
}

locals {
  aws_ecr_repository_name = var.AWS_RESOURCE_PREFIX
  aws_ecs_cluster_name    = "${var.AWS_RESOURCE_PREFIX}-cluster"
  aws_ecs_service_name    = "${var.AWS_RESOURCE_PREFIX}-service"
}



