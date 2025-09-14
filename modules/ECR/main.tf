resource "aws_ecr_repository" "repos" {
  for_each             = toset(var.ecr_repos)
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}