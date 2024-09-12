resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidir_blocks)
  vpc_id                  = aws_vpc.padhma.id
  cidr_block              = element(var.public_cidir_blocks, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.padhma.id
  count             = length(var.private_cidir_blocks)
  cidr_block        = element(var.private_cidir_blocks, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}