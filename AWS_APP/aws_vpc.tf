resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block #"10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_public_cidr_block #"10.0.1.0/25"
  availability_zone = var.aws_region

  tags = {
    "Name" = "public | ${var.aws_region}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_private_cidr_block #"10.0.2.0/25"
  availability_zone = var.aws_region

  tags = {
    "Name" = "private | ${var.aws_region}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    "Name" = "${var.aws_region}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    "Name" = "${var.aws_region}-private"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_d.id
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

# resource "aws_security_group" "http" {
#   name        = "http"
#   description = "HTTP traffic"
#   vpc_id      = aws_vpc.app_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "https" {
#   name        = "https"
#   description = "HTTPS traffic"
#   vpc_id      = aws_vpc.app_vpc.id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

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