# Helm Release Outputs
output "argocd_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.argocd.metadata
}

output "argocd_initial_admin_password" {
  value = data.kubernetes_secret.argocd_initial_password.data.password
}
