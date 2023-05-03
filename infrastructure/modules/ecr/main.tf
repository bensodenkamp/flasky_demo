resource "aws_ecr_repository" "flasky-repo" {
  name			= "flasky-repo"
  image_tag_mutability	= "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "flasky-repo-policy" {
  repository		= aws_ecr_repository.flasky-repo.name
policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}
