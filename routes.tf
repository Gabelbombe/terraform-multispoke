resource "aws_ec2_transit_gateway_route_table_association" "spoke_shared" {
  count                          = (var.spoke_type == "shared" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_shared_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_shared" {
  count                          = length(data.aws_vpcs.spoke_vpcs.ids)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_shared_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke_prod" {
  count                          = (var.spoke_type == "prod" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_prod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_prod" {
  count                          = (var.spoke_type == "prod" || var.spoke_type == "shared" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_prod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke_preprod" {
  count                          = (var.spoke_type == "preprod" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_preprod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_preprod" {
  count                          = (var.spoke_type == "preprod" || var.spoke_type == "shared" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.outputs.transit_gw_preprod_route_table_id
}
