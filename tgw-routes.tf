resource "aws_ec2_transit_gateway_route_table_association" "spoke_common" {
  provider                       = "aws.hub"
  count                          = (var.spoke_type == "common" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_common_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_common" {
  provider                       = "aws.hub"
  count                          = length(data.aws_vpcs.spoke_vpcs.ids)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_common_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke_prod" {
  provider                       = "aws.hub"
  count                          = (var.spoke_type == "prod" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_prod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_prod" {
  provider                       = "aws.hub"
  count                          = (var.spoke_type == "prod" || var.spoke_type == "common" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_prod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke_preprod" {
  provider                       = "aws.hub"
  count                          = (var.spoke_type == "preprod" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_preprod_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_preprod" {
  provider                       = "aws.hub"
  count                          = (var.spoke_type == "preprod" || var.spoke_type == "common" ? length(data.aws_vpcs.spoke_vpcs.ids) : 0)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
  transit_gateway_route_table_id = data.terraform_remote_state.hub.transit_gw_preprod_route_table_id
}
