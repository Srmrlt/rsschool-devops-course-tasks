# rsschool-devops-course-tasks

## Task_1: AWS Terraform Infrastructure Setup
This repository contains Terraform configurations and a GitHub Actions workflow for deploying infrastructure to AWS as part of the RS School DevOps course.

### Included Features

- **Bootstrap setup** to initialize an S3 bucket for storing Terraform states.
- **Main Terraform configuration** with S3 backend and a test S3 bucket creation.
- **GitHub Actions workflow** with three jobs:
  - `terraform-check` (runs `terraform fmt`)
  - `terraform-plan` (runs `terraform plan`)
  - `terraform-apply` (runs `terraform apply`)

### Terraform State Management

Terraform state is stored in an S3 bucket and locking with DynamoDB is configured via a dedicated bootstrap script.

### GitHub Actions OIDC Integration

- An IAM role `GithubActionsRole` was created with the necessary permissions.
- An OIDC Identity Provider was configured for GitHub.
- Trust policy allows GitHub Actions to assume the IAM role securely.

### Structure

- `bootstrap/`: contains code for initial S3 state bucket creation.
- `terraform/`: contains the primary infrastructure configuration (test S3 bucket, backend, etc).
- `.github/workflows/terraform.yml`: GitHub Actions workflow.

## How to Use

1. Clone the repository.
2. Review and modify the Terraform configuration if needed.
3. Push changes to a branch and create a pull request to `main`.
4. GitHub Actions workflow will validate, plan, and apply the changes automatically.

## Requirements

- Terraform >= 1.6
- AWS CLI v2
