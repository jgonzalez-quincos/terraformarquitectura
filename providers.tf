terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
            }
        }
    backend "s3" {
        bucket = "jgq-lab-vs-1"
        key = "TerraformBasic/TerraformBasic.tfstate"
        use_lockfile = true
        region = "us-east-1"
        encrypt = true
        profile = "seminario2"
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
}