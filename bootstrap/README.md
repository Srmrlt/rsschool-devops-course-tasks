# Terraform Bootstrap: Remote State Backend

This module **creates an S3 bucket for Terraform state and a DynamoDB
table for state locking**.  
Run it once per AWS account — afterwards point every other Terraform
workspace to the generated bucket/table.

---

## How to use

1) Init & apply the bootstrap stack
```bash
terraform init
terraform apply
```

## Outputs

| Name | Description |
|------|-------------|
| `state_bucket_name`   | S3 bucket that stores `.tfstate` |
| `dynamodb_table_name` | DynamoDB table that holds the lock |

---

## Clean-Up

To destroy the bootstrap resources **make sure no workspace is still using the bucket**, then run:

```bash
terraform destroy
```
