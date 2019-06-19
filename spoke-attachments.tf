resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  count              = length(data.aws_vpcs.spoke_vpcs.ids)
  subnet_ids         = [slice(flatten(data.aws_subnet_ids.spoke_subnets.*.ids), count.index * 3, (count.index + 1) * 3)]
  transit_gateway_id = data.terraform_remote_state.hub.outputs.transit_gw_id
  vpc_id             = data.aws_vpcs.spoke_vpcs.ids[count.index]
  dns_support        = var.dns_support
  ipv6_support       = var.ipv6_support

  tags = {
    Name = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace")
  }
}

resource "null_resource" "hub_attachment_update" {
  count = length(data.aws_vpcs.spoke_vpcs.ids)

  triggers = {
    attachment_id = data.aws_ec2_transit_gateway_vpc_attachment.hub.*.id[count.index]
    Name          = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace")
  }

  provisioner "local-exec" {
    command = templatefile("${path.module}/hub_template.tpl", {[
      region    = var.aws_region,
      profile   = var.credentials_profile,
      resources = data.aws_ec2_transit_gateway_vpc_attachment.hub.*.id[count.index],
      values    = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace"),
    ]})
  }
}
