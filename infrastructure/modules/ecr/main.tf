resource "aws_ecr_repository" "flasky-repo" {
  name			            = "flasky-repo"
  image_tag_mutability	= "MUTABLE"
}

output "repo_arn" {
  value = aws_ecr_repository.flasky-repo.arn
}

output "repo_url" {
  value = aws_ecr_repository.flasky-repo.repository_url
}