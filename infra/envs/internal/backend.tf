terraform {
    backend "s3" {
        bucket = "amzn-s3-tf-state-bucket"
        key = "ci/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}