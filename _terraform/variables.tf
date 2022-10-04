

variable "ECS_AMI" {}
variable "INSTANCE_TYPE" {}
variable "AWS_REGION" {}
variable "AWS_RESOURCE_PREFIX" {}
variable "EMAIL" {}

locals {
  aws_ecr_repository_name = var.AWS_RESOURCE_PREFIX
  aws_ecs_cluster_name    = "${var.AWS_RESOURCE_PREFIX}-cluster"
  aws_ecs_service_name    = "${var.AWS_RESOURCE_PREFIX}-service"
}



