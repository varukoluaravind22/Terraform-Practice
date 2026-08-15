# resource "aws_dynamodb_table" "terraform-lock" {
#   name = "terraform-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
terraform {
    backend "s3" {
      bucket = "appchunk"
      key = "Entire_arch/terraform.tfstate"
      region = "ap-south-1"
      encrypt = true
      #dynamodb_table = "terraform-lock"
      use_lockfile = true
    }
}

