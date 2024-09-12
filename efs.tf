# IAM Role for EFS CSI Driver
resource "aws_iam_role" "efs_csi_driver" {
  name = "efs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_driver.name
}


# EFS File System
resource "aws_efs_file_system" "efs" {
  creation_token = "efs"

  tags = {
    Name = "EFSForEKS"
  }
}

# EFS Mount Targets
resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.private_cidir_blocks)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(aws_subnet.private_subnet[*].id, count.index)
  security_groups = [aws_security_group.efs.id]
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Allow inbound NFS traffic from EKS"
  vpc_id      = aws_vpc.padhma.id

  ingress {
    description = "NFS from EKS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a ConfigMap to store EFS mount target IPs
resource "kubernetes_config_map" "efs_mount_targets" {
  metadata {
    name      = "efs-mount-targets"
    namespace = "kube-system"
  }

  data = {
    mount_target_ips = join(",", aws_efs_mount_target.efs_mount[*].ip_address)
  }
}
