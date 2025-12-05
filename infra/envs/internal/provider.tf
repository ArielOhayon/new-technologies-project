provider "aws" {
    region = var.aws_region                 # region to work in

    assume_role {
        role_arn = var.terraform_role_arn
        session_name = "terraform-${var.environment}"   # dynamic session name per env for cloudtrail
        external_id = var.external_id
    }
}