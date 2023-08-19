resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_public_a_cidr_block
  availability_zone = var.aws_availability_zone_a

  tags = {
    "Name" = "public | ${var.aws_availability_zone_a}"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_public_b_cidr_block
  availability_zone = var.aws_availability_zone_b

  tags = {
    "Name" = "public | ${var.aws_availability_zone_b}"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_private_a_cidr_block
  availability_zone = var.aws_availability_zone_a

  tags = {
    "Name" = "private | ${var.aws_availability_zone_a}"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_private_b_cidr_block
  availability_zone = var.aws_availability_zone_b

  tags = {
    "Name" = "private | ${var.aws_availability_zone_b}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    "Name" = "${var.aws_availability_zone}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    "Name" = "${var.aws_availability_zone}-private"
  }
}

resource "aws_route_table_association" "public_a_subnet" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b_subnet" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a_subnet" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b_subnet" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}


resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_api" {
  name        = "ingress-${var.ecs_service_name}-${var.aws_region}"
  description = "Allow ingress to API"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = var.task_port
    to_port     = var.task_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}