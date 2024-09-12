# Storage Class
resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
  }

  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs.id
    directoryPerms   = "700"
  }
}

# Example PersistentVolume
resource "kubernetes_persistent_volume" "efs_pv" {
  metadata {
    name = "efs-pv"
  }

  spec {
    capacity = {
      storage = "5Gi"
    }
    volume_mode = "Filesystem"
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = kubernetes_storage_class.efs_sc.metadata[0].name
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }
  }
}

# Example PersistentVolumeClaim
resource "kubernetes_persistent_volume_claim" "efs_pvc" {
  metadata {
    name = "efs-pvc"
  }

  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.efs_sc.metadata[0].name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}