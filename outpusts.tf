output "lbc_iam_policy" {
  #value = data.http.lbc_iam_policy.body
  value = data.http.lbc_iam_policy.response_body
}

# Helm Release Outputs
output "lbc_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.loadbalancer_controller.metadata
}

# Helm Release Outputs
output "externaldns_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.external_dns.metadata
}

# Helm Release Outputs
output "cluster_autoscaler_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.cluster_autoscaler_release.metadata
}

# Helm Release Outputs
output "metrics_server_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.metrics_server_release.metadata
}

output "argocd_initial_admin_password" {
  value     = data.kubernetes_secret.argocd_initial_password.data.password
  sensitive = true # Marca el output como sensible para que no se muestre en los logs
}
