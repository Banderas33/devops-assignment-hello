# Terraform backend configuration
# IMPORTANT:
# The S3 bucket must exist before enabling this backend.
#
# After creating the bucket, uncomment the backend block and run:
# terraform init -migrate-state

# terraform {
#   backend "s3" {
#     bucket = "hello-devops-terraform-state-yourname"
#     key    = "devops-assignment/terraform.tfstate"
#     region = "eu-west-1"
#   }
# }