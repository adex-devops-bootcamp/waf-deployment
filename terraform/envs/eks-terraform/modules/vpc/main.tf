##################################################
# VPC
##################################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = var.vpc_name }
}

##################################################
# Internet Gateway
##################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.vpc_name}-igw" }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}



##################################################
# Public Subnets
##################################################
resource "aws_subnet" "public" {
  count                   = length(var.public_azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = var.public_azs[count.index]
  map_public_ip_on_launch = true
 tags = {
  Name = "${var.vpc_name}-public-${count.index + 1}"
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
}
}

##################################################
# Private Subnets
##################################################
resource "aws_subnet" "private" {
  count             = length(var.private_azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets_cidrs[count.index]
  availability_zone = var.private_azs[count.index]

tags = {
  Name = "${var.vpc_name}-private-${count.index + 1}"
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
}
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }

  depends_on = [aws_internet_gateway.this]
}

##################################################
# Public Route Table
##################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "${var.vpc_name}-public-rt" }
}


##################################################
# Private Route Table
##################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

##################################################
# Associate Public Subnets with Route Table
##################################################
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

##################################################
# Associate Private Subnets with Route Table
##################################################
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
