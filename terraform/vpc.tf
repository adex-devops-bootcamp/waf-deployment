# VPC

resource "aws_vpc" "sonar_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-sonarqube-vpc"
  }
}

# PUBLIC SUBNETS

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets) # Number of public subnet will be created aws_subnet.public[0], aws_subnet.public[1]
  vpc_id                  = aws_vpc.sonar_vpc.id
  cidr_block              = var.public_subnets[count.index]     # Assigning of CIDR according to index [0], [1]
  availability_zone       = var.availability_zones[count.index] # Assigning of AZ according to index [0], [1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}" # aws_subnet.public[0] --> dev-public-subnet-1
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sonar_vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# PUBLIC ROUTE TABLE

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sonar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public) # Multiple subnet association
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# NAT GATEWAY
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.environment}-nat-gateway"
  }
}

# PRIVATE SUBNETS

resource "aws_subnet" "private" {
  count             = length(var.private_subnets) # Number of private subnet will be created aws_subnet.private[0], aws_subnet.private[1]
  vpc_id            = aws_vpc.sonar_vpc.id
  cidr_block        = var.private_subnets[count.index]    # Assigning of CIDR according to index [0], [1]
  availability_zone = var.availability_zones[count.index] # Assigning of AZ according to index [0], [1]

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}


# PRIVATE ROUTE TABLE

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.sonar_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private) # Multiple subnet association
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
