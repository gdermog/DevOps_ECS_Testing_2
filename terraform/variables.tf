variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-central-1"
}

variable "aws_container_repo_name" {
  description = "Identification of docker image in ECR"
  type        = string
  default     = "docker-nginx"
}

variable "project_name" {
  default = "ecs-nginx-demo-2"
}
