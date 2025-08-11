
resource "aws_ecr_repository" "nginxposp" {

  name = var.aws_container_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Owner = "V. Pospisil"
  }
  
}