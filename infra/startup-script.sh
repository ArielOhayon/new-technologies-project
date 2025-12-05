# ssm parameter store command to retrieve external id for terraform.

useaws terraform-admin

TF_VAR_external_id=$(aws ssm get-parameter \
  --name "external_id")

export TF_VAR_external_id
# Terraform plan, then prompt for confirmation, then apply