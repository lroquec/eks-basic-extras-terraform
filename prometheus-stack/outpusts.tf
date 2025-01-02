# Helm Release Outputs
output "prometheus_community_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.prometheus_community.metadata
}
