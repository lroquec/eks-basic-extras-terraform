# AWS Load Balancer Controller - Terraform Implementation Documentation

## Overview
This project implements the AWS Load Balancer Controller for EKS (Elastic Kubernetes Service) using Terraform. The Load Balancer Controller helps manage AWS Elastic Load Balancers for a Kubernetes cluster.

## Project Structure
```
├── lbc-iam-policy-and-role.tf    # IAM policies and roles configuration
├── lbc-install.tf                # Helm chart installation
├── ingress-class.tf             # Default ingress class configuration
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

### Ingress Class Configuration
The project sets up a default ingress class with the following specifications:
- Name: my-aws-ingress-class
- Default class: Yes (marked as default ingress class)
- Controller: ingress.k8s.aws/alb (AWS Application Load Balancer)
- Dependencies: Requires successful installation of Load Balancer Controller

### Remote State
The project uses an S3 backend for storing Terraform state:
- Bucket: lroquec-tf (you have to create your own).
- Key: eks/eks-terraform.tfstate

## Prerequisites
- An existing EKS cluster. [You can use this repo for that purpose](https://github.com/lroquec/terraform-eks-setup.git) 
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- [Terraform](https://www.terraform.io/downloads) installed
- [Helm](https://helm.sh/docs/intro/install/) installed

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
- Existing EKS cluster
- EKS OIDC provider configuration
- VPC configuration

## Notes
- The Load Balancer Controller image repository URL is region-specific (configured for us-east-1)
- The IAM policy is fetched from the official [AWS Load Balancer Controller GitHub repository](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
- The implementation uses Terraform's remote state functionality for accessing EKS cluster details
- The ingress class is set as default, meaning it will be used for ingress resources that don't explicitly specify a class

For more information, refer to:
- [AWS Load Balancer Controller Documentation](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [EKS Workshop](https://www.eksworkshop.com/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

# ExternalDNS Terraform Project

## Overview
This project is designed to set up and configure **ExternalDNS** for an EKS (Elastic Kubernetes Service) cluster using Terraform. It includes creating IAM roles and policies, deploying the ExternalDNS Helm chart, and managing necessary configurations and dependencies.

ExternalDNS simplifies the process of updating DNS records for Kubernetes resources (e.g., Services and Ingresses). This setup integrates with AWS Route53 to manage DNS records dynamically.

---

## Features
- **IAM Policy and Role**: Provision necessary IAM policies and roles to allow ExternalDNS to interact with Route53.
- **Helm Deployment**: Install the ExternalDNS Helm chart with custom values.
- **Outputs**: Provide metadata and status for deployed resources.
- **Remote State**: Use a Terraform remote backend (S3) for state management.

---

## Prerequisites
1. An EKS cluster already set up.
2. AWS CLI installed and configured.
3. Terraform version `>= 1.7.0`.
4. Helm CLI installed.
5. A registered domain in Route53.
6. An SSL certificate issued via AWS Certificate Manager (ACM).

### Domain Registration and SSL Certificate Setup
- **Domain Registration in Route53**:
  1. Navigate to the Route53 console in AWS.
  2. Register a new domain or transfer an existing one.
  3. Create a hosted zone for managing DNS records.
- **SSL Certificate in ACM**:
  1. Open the ACM console.
  2. Request a public certificate for your domain.
  3. Validate the domain ownership using DNS validation (recommended).
  4. Once validated, the certificate will be available for use with AWS services.

---

## Usage

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Variables
Update the `variables.tf` file or use a `terraform.tfvars` file to specify values for the following:
- `aws_region`: AWS region (default: `us-east-1`).
- `environment`: Environment name (e.g., `dev`, `prod`).
- `business_division`: Business division (e.g., `billing`).

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan and Apply Configuration
- Preview the changes:
  ```bash
  terraform plan
  ```
- Apply the changes:
  ```bash
  terraform apply
  ```

### 5. Outputs
Once applied, Terraform will output information about the created resources, such as:
- IAM Policy ARN
- IAM Role ARN
- Helm Release Metadata

---

## Files and Modules

### Core Files
1. **`providers.tf`**:
   - Configures AWS, Helm, Kubernetes, and HTTP providers.
   - Uses an S3 backend for Terraform state.
2. **`shared-datasources.tf`**:
   - Defines remote state data sources and EKS cluster authentication.
3. **`shared-locals.tf`**:
   - Local values for consistent naming and tagging.
4. **`variables.tf`**:
   - Input variables with default values for region, environment, and business division.
5. **`externaldns-iam-policy-and-role.tf`**:
   - Creates the IAM policy and role for ExternalDNS.
   - Attaches the policy to the role.
6. **`externaldns-install.tf`**:
   - Deploys ExternalDNS using Helm and customizes its configuration.
7. **`outputs.tf`**:
   - Exposes resource metadata for use in other modules or debugging.

---

## Key Configurations

### IAM Policy
Defines permissions for ExternalDNS to manage Route53 resources, including:
- Changing DNS records (`route53:ChangeResourceRecordSets`).
- Listing hosted zones and record sets (`route53:ListHostedZones`, `route53:ListResourceRecordSets`).

### Helm Chart
Deploys the ExternalDNS Helm chart with the following settings:
- **Image Repository**: `registry.k8s.io/external-dns/external-dns`
- **Service Account**: Auto-created and annotated with the IAM role.
- **Provider**: AWS.
- **Policy**: `sync` to ensure DNS record synchronization.

---

## Deployment Architecture
1. Terraform provisions an IAM policy and role.
2. The IAM role is annotated in the Kubernetes Service Account for ExternalDNS.
3. Helm installs ExternalDNS in the default namespace, enabling it to manage Route53 records.

---

