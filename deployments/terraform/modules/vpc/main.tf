resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      "Name" = "${var.name}-vpc"
    },
    var.tags,
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = "${var.name}-igw"
    },
    var.tags,
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = "${var.name}-public-subnet-${count.index + 1}"
    },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    {
      "Name" = "${var.name}-public-rt"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = length(var.private_subnets) > 0 ? length(var.azs) : 0
  domain = "vpc"

  tags = merge(
    {
      "Name" = "${var.name}-nat-eip-${count.index + 1}"
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnets) > 0 ? length(var.azs) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" = "${var.name}-nat-gw-${count.index + 1}"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    {
      "Name" = "${var.name}-private-subnet-${count.index + 1}"
    },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets) > 0 ? length(var.azs) : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(
    {
      "Name" = "${var.name}-private-rt-${count.index + 1}"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index % length(aws_route_table.private)].id
}