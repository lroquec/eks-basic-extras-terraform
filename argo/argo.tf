resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.7.11"
  timeout          = 600

  values = [file("values/argocd.yaml")]
}

# Namespace Argo Rollouts
resource "kubernetes_namespace" "argo_rollouts" {
  metadata {
    name = "argo-rollouts"
  }
}

# Manifest for Argo Rollouts
data "http" "argorollouts_manifest" {
  url = "https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml"
}

# Manifest for Argo CD Image Updater
data "http" "argocd_image_updater_manifest" {
  url = "https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml"
}

# Argo CD Image Updater
resource "kubernetes_manifest" "argocd_image_updater" {
  depends_on = [helm_release.argocd]

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

data "kubernetes_secret" "argocd_initial_password" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}
