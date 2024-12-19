# EKS Cluster Extras

## Overview
This project provides a collection of essential configurations and resources that are typically added to an Amazon EKS cluster after its initial deployment. It simplifies the process of setting up frequently required tools and configurations, ensuring consistency and ease of deployment.

## Features
The project includes the following components:

1. **Ingress Configuration**: Sets up the ingress controller and related resources.
2. **Load Balancer Controller**:
   - IAM policies and roles.
   - Installation of the AWS Load Balancer Controller.
3. **Cluster Autoscaler**:
   - IAM policies and roles.
   - Installation of the Cluster Autoscaler.
4. **ExternalDNS**:
   - IAM policies and roles.
   - Installation of ExternalDNS.
5. **Shared Resources**:
   - Common data sources.
   - Shared variables and local definitions.

## Files

### Configuration Files
- **`ingress-class.tf`**: Configuration for the ingress class.
- **`lbc-iam-policy-and-role.tf`**: IAM policies and roles for the AWS Load Balancer Controller.
- **`lbc-install.tf`**: Installation of the AWS Load Balancer Controller.
- **`cluster-autoscaler-iam-policy-and-role.tf`**: IAM policies and roles for the Cluster Autoscaler.
- **`cluster-autoscaler-install.tf`**: Installation of the Cluster Autoscaler.
- **`externaldns-iam-policy-and-role.tf`**: IAM policies and roles for ExternalDNS.
- **`externaldns-install.tf`**: Installation of ExternalDNS.
- **`providers.tf`**: Provider configurations.
- **`shared-datasources.tf`**: Shared data sources for Terraform.
- **`shared-locals.tf`**: Shared local variables.
- **`variables.tf`**: Definition of input variables.
- **`outputs.tf`**: Definition of output variables.

## Component Details

### Ingress Configuration
The ingress controller is configured to manage external access to services running in the EKS cluster. This includes defining the ingress class and setting up rules for routing traffic to the appropriate services.

### AWS Load Balancer Controller
- **IAM Policies and Roles**: Required permissions are created to allow the controller to manage AWS resources such as Elastic Load Balancers.
- **Installation**: The controller is deployed into the cluster using Helm charts or manifests, enabling seamless integration with AWS load balancing features.

### Cluster Autoscaler
- **IAM Policies and Roles**: Permissions are granted for the autoscaler to scale nodes up or down based on workload demands.
- **Installation**: The autoscaler is deployed as a Kubernetes Deployment, monitoring the cluster's state and adjusting node counts accordingly.

### ExternalDNS
- **IAM Policies and Roles**: Permissions are set for managing DNS records in Route 53 or other DNS services.
- **Installation**: ExternalDNS is deployed as a Kubernetes Deployment to automatically update DNS records based on the state of Kubernetes resources like Ingress or Service.

### Shared Resources
- **Shared Data Sources**: Centralized data sources to retrieve commonly used AWS or Kubernetes information.
- **Shared Locals**: Predefined local variables to standardize configuration across modules.

## Prerequisites

- An existing Amazon EKS cluster. [You can use this repo for that purpose](https://github.com/lroquec/terraform-eks-setup.git) 
- Terraform installed on your local machine.
- AWS CLI configured with appropriate credentials and permissions.
- IAM roles and policies with the necessary permissions to manage resources in AWS.

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

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and adjust variables as needed in `variables.tf`.

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Usage
- The configuration files are modular, allowing you to deploy only the components you need.
- Remember: you need to create your own S3 bucket for remote state file and also your own DNS name purchased.
- Adjust the variables in `variables.tf` to match your specific requirements.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
