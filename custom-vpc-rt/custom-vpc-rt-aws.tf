provider "aws" {
  profile = var.profile
  region  = var.region
}

### VPC.
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr
  tags = {
    Name = var.vpc.name
  }
}

### IGW.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw.name
  }
}

### Subnets.
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

### Route tables.
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.rt1.name
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.rt2.name
  }
}

### Subnet association to route table.
resource "aws_route_table_association" "rt1_subnet1" {
  subnet_id      = aws_subnet.subnets["subnet1"].id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rt2_subnet2" {
  subnet_id      = aws_subnet.subnets["subnet2"].id
  route_table_id = aws_route_table.rt2.id
}

### RFC 1918 routes pointing to Spoke GW ENI in RT1, once the Spoke GW
### is attached to the Transit GW.
### Don't touch anything in RT2.
data "aws_instance" "spoke_gw_instance" {
  instance_id = aviatrix_spoke_gateway.spoke_gw.cloud_instance_id
}

resource "aws_route" "rt1_avx_routes" {
  count                  = length(var.routes)
  route_table_id         = aws_route_table.rt1.id
  destination_cidr_block = var.routes[count.index]
  network_interface_id   = data.aws_instance.spoke_gw_instance.network_interface_id
}

