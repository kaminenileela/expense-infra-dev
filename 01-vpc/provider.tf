terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.48.0"
    }
    }
    backend "s3" {
        bucket = "leelaexpense-remote-state"
        key = "expense-dev-vpc"
        region = "us-east-1"
        dynamodb_table = "expense-dynamo" #LockID

    }
 }

provider "aws" {
    region ="us-east-1"
}