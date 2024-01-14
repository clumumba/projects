
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "my-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)

  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.private_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    "Name"                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}
# Create a NAT Gateway in one of the public subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "nat"
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {

  tags = {
    Name = "nat"
  }
}

# Create routing tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public_rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private_rt"
  }
}

# Associate subnets with the appropriate routing tables
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}

/*
resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private.*.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private.*.id
  route_table_id = aws_route_table.private_route_table.id
}
*/