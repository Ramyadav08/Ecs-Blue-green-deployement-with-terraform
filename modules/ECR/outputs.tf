output "repository_urls" {
  description = "ECR repository URLs for all repositories"
  value = {
    for name, repo in aws_ecr_repository.repos :
    name => repo.repository_url
  }
}