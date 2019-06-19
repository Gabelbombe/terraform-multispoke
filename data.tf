locals {
  distinct_subnets                 = [distinct(flatten(data.aws_subnet_ids.spoke_subnets.*.ids))]
  distinct_associated_route_tables = [distinct(flatten(data.aws_route_tables.spoke.*.ids))]
}

data "aws_vpcs" "spoke_vpcs" {
  filter {
    name   = "isDefault"
    values = ["false"]
  }
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
    values = [local.distinct_subnets]
  }
}
