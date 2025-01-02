terraform {
  required_version = ">= 1.7.0"
  backend "s3" {
    bucket = "lroquec-tf"
    key    = "eks/aws-lbc/terraform.tfstate"
    region = "us-east-1"
    # For State Locking. Required for production environments
    # dynamodb_table = "demo-ekscluster"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      CreatedBy = "lroquec"
      Owner     = "DevOps Team"
    }
  }
}

# HELM Provider
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}