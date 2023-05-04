terraform {
  backend "s3" {
    bucket         = "terraform-state-z2qxqmlxp4qxi6yzi4ftn"
    key            = "global/s3/terraform.terraformstate"
    region         = "us-west-2"

    dynamodb_table = "terraform-locks-yarlhvupcfremha8wqdong"
    encrypt        = true
  }
}
