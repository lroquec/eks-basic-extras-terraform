resource "kubernetes_secret" "repo_system_info_ssh" {
  metadata {
    name      = "system-info-secret"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url           = "ssh://git@github.com/lroquec/k8s_nginx.git"
    sshPrivateKey = file("${path.module}/ssh-key")
    insecure      = "false"
    enableLfs     = "false"
  }
}