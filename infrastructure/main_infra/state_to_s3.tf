terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-z2qxqmlxp4qxi6yzi4ftn"
    key            = "global/s3/terraform.terraformstate"
    region         = "us-west-2"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-locks-yarlhvupcfremha8wqdong"
    encrypt        = true
  }
}
