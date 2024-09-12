resource "aws_vpc" "padhma" {
  cidr_block = var.vpc_cidir_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}