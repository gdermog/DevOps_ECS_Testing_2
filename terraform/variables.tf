variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-central-1"
}

variable "aws_container_repo_name" {
  description = "Identification of docker image in ECR"
  type        = string
  default     = "docker-nginx-pospisilv-hello-2"
}

variable "aws_container_repo_full" {
  description = "Identification of docker image in ECR - full path"
  type        = string
  default     = "624876161801.dkr.ecr.eu-central-1.amazonaws.com/docker-nginx-pospisilv-hello-2:latest"
}

variable "project_name" {
  default = "ecs-nginx-demo-2"
}

# Namespace pro vlastní metriku z logů
variable "custom_metric_namespace" {
  type    = string
  default = "Custom/ECS"
}

# Filtrační pattern: výchozí pro JSON logy s polem "status"
variable "http200_filter_pattern" {
  type    = string
  default = "[ip, ident, user, timestamp, request, status=200, size]"
}
