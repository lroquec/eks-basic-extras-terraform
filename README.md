# AWS Load Balancer Controller - Terraform Implementation Documentation

## Overview
This project implements the AWS Load Balancer Controller for EKS (Elastic Kubernetes Service) using Terraform. The Load Balancer Controller helps manage AWS Elastic Load Balancers for a Kubernetes cluster.

## Project Structure
```
├── lbc-iam-policy-and-role.tf    # IAM policies and roles configuration
├── lbc-install.tf                # Helm chart installation
├── shared-datasources.tf         # Shared data sources configuration
├── shared-locals.tf             # Local variables definition
└── variables.tf                 # Input variables definition
```

## Components

### Variables
The project uses the following variables:
- `aws_region`: AWS region where resources will be created (default: us-east-1)
- `environment`: Environment prefix for resources (default: dev)
- `business_division`: Business division identifier (default: billing)

### IAM Configuration
The project creates necessary IAM resources:
- An IAM policy for the Load Balancer Controller
- An IAM role with AssumeRoleWithWebIdentity permissions
- Policy attachment linking the policy to the role

The IAM role is configured to work with EKS OIDC provider for authentication.

### Load Balancer Controller Installation
The controller is installed using Helm with the following configuration:
- Repository: https://aws.github.io/eks-charts
- Chart: aws-load-balancer-controller
- Namespace: kube-system
- Service Account: Configured with appropriate IAM role annotations
- Region-specific ECR image repository

### Remote State
The project uses an S3 backend for storing Terraform state:
- Bucket: lroquec-tf
- Key: eks/eks-terraform.tfstate

## Prerequisites
- An existing EKS cluster
- AWS CLI configured with appropriate permissions
- Terraform installed
- Helm installed

## Resource Naming Convention
Resources are named using the pattern: `{business_division}-{environment}-{resource-specific-name}`

## Outputs
The project provides the following outputs:
- `lbc_iam_policy_arn`: ARN of the created IAM policy
- `lbc_iam_role_arn`: ARN of the created IAM role

## Tags
Resources are tagged with:
- `owners`: Business division
- `environment`: Deployment environment

## Security Considerations
- The IAM role is configured with specific conditions for the EKS OIDC provider
- Service account is created with limited permissions
- Role assumes least privilege principle

## Dependencies
The project depends on:
- VPC configuration and existing EKS cluster. [You can use this repo for that purpose](https://github.com/lroquec/terraform-eks-setup.git) 

## Notes
- The Load Balancer Controller image repository URL is region-specific (configured for us-east-1)
- The IAM policy is fetched from the official AWS Load Balancer Controller GitHub repository
- The implementation uses Terraform's remote state functionality for accessing EKS cluster details

This documentation provides a comprehensive overview of the AWS Load Balancer Controller implementation using Terraform. For specific deployment instructions or troubleshooting, please refer to the AWS EKS documentation and the AWS Load Balancer Controller GitHub repository.
