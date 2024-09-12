resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.padhma.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }

}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.padhma.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }

}


resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_cidir_blocks)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_cidir_blocks)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
