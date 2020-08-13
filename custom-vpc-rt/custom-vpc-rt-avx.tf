### Spoke gateway.
### Set customized_spoke_vpc_routes to 0.0.0.0/32, so we don't touch the
### VPC route tables.
resource "aviatrix_spoke_gateway" "spoke_gw" {
  cloud_type                  = var.cloud_type
  account_name                = var.account_name
  gw_name                     = var.spoke_gateway.name
  vpc_id                      = aws_vpc.vpc.id
  vpc_reg                     = var.region
  gw_size                     = var.spoke_gateway.size
  enable_active_mesh          = var.spoke_gateway.active_mesh
  single_az_ha                = var.spoke_gateway.single_az_ha
  customized_spoke_vpc_routes = "0.0.0.0/32"
  subnet                      = aws_subnet.subnets["subnet1"].cidr_block
  transit_gw                  = var.spoke_gateway.transit_gw
}

