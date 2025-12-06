## December 5th 2025
1. Created basic file structure for tf infra
2. Created s3 bucket and dynamodb for backend, and created iam role for terraform - all in us-east-1 for cost reduction.
3. Created backend.tf, variables.tf, versions.tf, provider.tf and tf init top initialize backend on s3.

## December 6th 2025
1. Changed the state locking mechanism from dynamodb to native s3 locking due to dynamodb method depracation.
2. 