variable "aws_region" {
    description = "AWS region for resources"
    type = string
    default = "us-east-1"
}

variable "environment"{
    description = "env to work in"
    type = string
    default = "internal"
}

variable "terraform_role_arn" {
    description = "role arn for terraform to assume"
    type = string
    default = "arn:aws:iam::269272823657:user/ariel_user"
}

variable "external_id" {
    description = "external identifier for assuming terraform role (allowed only from my iam user)"
    type = string   # Will be exported as an env var under the name TF_VAR_external_id in the init script
    sensitive = true

    validation {
        condition = length(var.external_id) > 0
        error_message = "External ID cannot be empty. Ensure init script loaded it from Parameter Store."
  }
}