resource "aws_ecr_repository" "flasky-repo" {
  name			            = "flasky-repo"
  image_tag_mutability	= "MUTABLE"
}


data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.flasky-repo.arn]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions       = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:bensodenkamp/flasky_demo:*"]
    }

    condition {
      test      = "StringEquals"
      variable  = "token.actions.githubusercontent.com:aud"
      values    = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "github_actions" {
  name        = "github-actions-flasky"
  policy      = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-flasky-deployment"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}

output "repo_url" {
  value = aws_ecr_repository.flasky-repo.repository_url
}