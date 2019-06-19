resource "aws_ec2_transit_gateway_route_table" "common" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags {
    Name      = "TGW-Common"
    RouteType = "common"
  }
}

resource "aws_ec2_transit_gateway_route" "common-routes" {
  count                          = var.enable_common_routes ? length(var.common_destination_cidr_blocks) : 0
  destination_cidr_block         = lookup(var.common_destination_cidr_blocks[count.index], element(keys(var.common_destination_cidr_blocks[count.index]), 0), "127.0.0.1/32")
  transit_gateway_attachment_id  = element(keys(var.common_destination_cidr_blocks[count.index]), 0)
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.common.id
}
