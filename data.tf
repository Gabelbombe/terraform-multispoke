data "terraform_remote_state" "hub" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    region = var.aws_region
    bucket = "bucketname"
    key    = "terraform.tfstate"
  }
}

data "aws_vpcs" "spoke_vpcs" {
  filter {
    name   = "isDefault"
    values = ["false"]
  }
}

data "template_file" "hub_template" {
  template = "${path.module}/hub_template.tpl"

  vars = {
    region    = var.aws_region
    profile   = var.credentials_profile
    resources = data.aws_ec2_transit_gateway_vpc_attachment.hub.*.id[count.index]
    values    = lookup(data.aws_vpc.spoke_vpc.*.tags[count.index], "Name", "var.namespace")
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  count = length(data.aws_vpcs.spoke_vpcs.ids)
  id    = aws_ec2_transit_gateway_vpc_attachment.spoke.*.id[count.index]
}

data "aws_vpc" "spoke_vpc" {
  count = length(data.aws_vpcs.spoke_vpcs.ids)
  id    = data.aws_vpcs.spoke_vpcs.ids[count.index]
}

data "aws_subnet_ids" "spoke_subnets" {
  count  = length(data.aws_vpcs.spoke_vpcs.ids)
  vpc_id = data.aws_vpcs.spoke_vpcs.ids[count.index]

  tags = {
    Resource = var.subnet_tag_key
  }
}

data "aws_route_tables" "spoke" {
  count  = length(data.aws_vpcs.spoke_vpcs.ids)
  vpc_id = data.aws_vpcs.spoke_vpcs.ids[count.index]

  filter {
    name   = "association.subnet-id"
    values = local.distinct_subnets
  }
}

locals {
  distinct_subnets                 = distinct(flatten(data.aws_subnet_ids.spoke_subnets.*.ids))
  distinct_associated_route_tables = [distinct(flatten(data.aws_route_tables.spoke.*.ids))]
}
