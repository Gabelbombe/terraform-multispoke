
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  count              = length(data.aws_vpcs.spoke_vpcs.ids)
  subnet_ids         = [slice(flatten(data.aws_subnet_ids.spoke_subnets.*.ids), count.index * 3, (count.index + 1) * 3)]
  transit_gateway_id = data.terraform_remote_state.hub.transit_gw_id
  vpc_id             = data.aws_vpcs.spoke_vpcs.ids[count.index]
  dns_support        = var.dns_support
  ipv6_support       = var.ipv6_support

  tags {
    Name = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace")
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  count    = length(data.aws_vpcs.spoke_vpcs.ids)
  provider = "aws.hub"
  id       = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
}

resource "null_resource" "hub_attachment_update" {
  count = length(data.aws_vpcs.spoke_vpcs.ids)

  triggers = {
    attachment_id = data.aws_ec2_transit_gateway_vpc_attachment.hub.*.id[count.index]
    Name          = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace")
  }

  provisioner "local-exec" {
    command = "AWS_DEFAULT_REGION=${var.aws_region} AWS_PROFILE=${var.hub_account} aws ec2 create-tags --resources ${data.aws_ec2_transit_gateway_vpc_attachment.hub.*.id[count.index]} --tags Key=Name,Value=${lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], 'Name', 'var.namespace')"
  }
}
