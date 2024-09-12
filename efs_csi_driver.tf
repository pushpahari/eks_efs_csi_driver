# EFS CSI Driver Helm Release
resource "helm_release" "aws_efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/eks/aws-efs-csi-driver"
  }

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    kubernetes_service_account.efs_csi_driver
  ]
}

# # CSIDriver resource
# resource "kubernetes_manifest" "efs_csi_driver" {
#   manifest = {
#     apiVersion = "storage.k8s.io/v1"
#     kind       = "CSIDriver"
#     metadata = {
#       name = "efs.csi.aws.com"
#     }
#     spec = {
#       attachRequired = false
#     }
#   }

#   depends_on = [
#     helm_release.aws_efs_csi_driver
#   ]
# }
