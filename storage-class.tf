resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    encrypted = true
    type      = "gp3"
    fsType    = "ext4"
  }
}
