resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.padhma.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}