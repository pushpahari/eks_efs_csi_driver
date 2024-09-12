# Kubernetes Service Account
resource "kubernetes_service_account" "efs_csi_driver" {
  metadata {
    name      = "efs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.efs_csi_driver.arn
    }
  }
}