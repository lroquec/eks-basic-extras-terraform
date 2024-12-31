# Namespace Argo CD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Namespace Argo Rollouts
resource "kubernetes_namespace" "argo_rollouts" {
  metadata {
    name = "argo-rollouts"
  }
}

# Manifest for Argo CD
data "http" "argocd_manifest" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

# Manifest for Argo Rollouts
data "http" "argorollouts_manifest" {
  url = "https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml"
}

# Manifest for Argo CD Image Updater
data "http" "argocd_image_updater_manifest" {
  url = "https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml"
}

# Argo CD
resource "kubernetes_manifest" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  manifest = yamldecode(data.http.argocd_manifest.response_body)

  # Esto es necesario porque el manifest contiene múltiples recursos
  for_each = toset(split("---", data.http.argocd_manifest.response_body))

  field_manager {
    force_conflicts = true
  }
}

# Argo CD Image Updater
resource "kubernetes_manifest" "argocd_image_updater" {
  depends_on = [kubernetes_namespace.argocd]

  manifest = yamldecode(data.http.argocd_image_updater_manifest.response_body)

  for_each = toset(split("---", data.http.argocd_image_updater_manifest.response_body))

  field_manager {
    force_conflicts = true
  }
}

# Argo Rollouts
resource "kubernetes_manifest" "argo_rollouts" {
  depends_on = [kubernetes_namespace.argo_rollouts]

  manifest = yamldecode(data.http.argorollouts_manifest.response_body)

  for_each = toset(split("---", data.http.argorollouts_manifest.response_body))

  field_manager {
    force_conflicts = true
  }
}
