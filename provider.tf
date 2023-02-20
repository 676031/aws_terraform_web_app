terraform {
 backend "s3" {
   bucket         = "tf-state-12s3gm5s21"
   key            = "state/terraform.tfstate"
   region         = "us-east-1"
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state"
 }
}

provider "aws" {
  region = "us-east-1"
}

provider "docker" {
  # version = "~> 2.6"
  host    = "npipe:////.//pipe//docker_engine"
}