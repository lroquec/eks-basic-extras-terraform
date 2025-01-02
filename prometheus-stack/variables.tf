# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "billing"
}

variable "prometheus_namespace" {
  type    = string
  default = "monitoring"
}

variable "storage_class_name" {
  type    = string
  default = "ebs-sc"
}

variable "prometheus_storage_size" {
  type    = string
  default = "10Gi"
}

variable "helm_prometheus_chart_version" {
  type    = string
  default = "67.5.0"
}