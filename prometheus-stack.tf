resource "kubernetes_namespace" "prometheus_namespace" {
  metadata {
    name = var.prometheus_namespace
  }
}

locals {
  prometheus_values = templatefile("${path.module}/prometheus-values.tpl.yaml", {
    storage_class_name      = var.storage_class_name
    prometheus_storage_size = var.prometheus_storage_size
  })
}

resource "helm_release" "prometheus_community" {
  name             = "prometheus-community"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.prometheus_namespace.metadata[0].name
  create_namespace = true
  version          = var.helm_prometheus_chart_version
  values           = [local.prometheus_values]
  wait             = true
  timeout          = 600
}

resource "kubernetes_persistent_volume_claim" "grafana_pvc" {
  metadata {
    name      = "grafana-pvc"
    namespace = var.prometheus_namespace
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata[0].name

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}
