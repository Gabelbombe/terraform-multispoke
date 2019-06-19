resource "aws_ec2_transit_gateway_route_table" "shared" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags {
    Name      = "TGW-Shared"
    RouteType = "shared"
  }
}

resource "aws_ec2_transit_gateway_route" "shared-routes" {
  count                          = var.enable_shared_routes ? length(var.destination_cidr_blocks) : 0
  destination_cidr_block         = lookup(var.destination_cidr_blocks[count.index], element(keys(var.destination_cidr_blocks[count.index]), 0), "127.0.0.1/32")
  transit_gateway_attachment_id  = element(keys(var.destination_cidr_blocks[count.index]), 0)
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared.id
}
