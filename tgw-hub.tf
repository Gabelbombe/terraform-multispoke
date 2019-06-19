resource "aws_ec2_transit_gateway" "main" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support

  tags {
    Name    = var.namespace
    Purpose = var.tag_purpose
  }
}

resource "aws_ram_resource_share" "main" {
  name                      = var.namespace
  allow_external_principals = var.allow_external_principals

  tags {
    Purpose = var.tag_purpose
  }
}

resource "aws_ram_principal_association" "account_associations" {
  count              = length(var.shared_accounts)
  principal          = var.shared_accounts[count.index]
  resource_share_arn = aws_ram_resource_share.main.id
}

resource "aws_ram_resource_association" "gateway_association" {
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.main.id
}
