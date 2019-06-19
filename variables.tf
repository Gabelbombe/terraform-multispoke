variable "aws_region" {
  type        = "string"
  description = "The AWS region to build in."
  default     = "us-west-2"
}

variable "allow_external_principals" {
  type        = "string"
  description = "Indicates whether principals outside your organization can be associated with a resource share."
  default     = "true"
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of the BGP session."
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  type        = "string"
  description = "Whether resource attachment requests are automatically accepted. One of ENABLE or DISABLE."
  default     = "enable"
}

variable "shared_destination_cidr_blocks" {
  type        = "list"
  description = "A list of tgw-vpc, cidr maps to apply to all hub route tables."

  default = [
    {
      "tgw-attach-00000000000000000" = "172.16.0.0/16"
    },
  ] # VPN
}

variable "credentials_profile" {
  type        = "string"
  description = "The name of the profile where credentials are stored."
  default     = "none"
}

variable "enable_shared_routes" {
  description = "Whether the shared routes should be applied (usally true after the first run)."
  default     = true
}

variable "default_route_table_association" {
  type        = "string"
  description = "Whether resource attachments are automatically associated with the default route table. One of ENBALE or DISABLE. If set to ENABLE, you must create a route table with default_association_route_table set to true."
  default     = "disable"
}

variable "default_route_table_propagation" {
  type        = "string"
  description = "Whether resource attachments are automatically propagating to the default route table. One of ENABLE or DISABLE. If set to ENABLE, you must create a route table with default_propagation_route_table set to true."
  default     = "disable"
}

variable "description" {
  type        = "string"
  description = "Description of the transit gateway."
  default     = "mygateway"
}

variable "destination_cidr_blocks" {
  type        = "map"
  description = "Destination of the cidr_blocks"

  default = {
    shared = [
      "192.168.0.0/16",
    ] # toward everything

    engineering = [
      "192.168.0.0/20",
    ] # toward shared

    production = [
      "192.168.0.0/20",
    ] # toward shared
  }
}

variable "dns_support" {
  type        = "string"
  description = "Whether public IPv4 to private IPv4 DNS support is enabled. One of ENABLE or DISABLE."
  default     = "disable"
}

variable "ipv6_support" {
  type        = "string"
  description = "Whether ipv6 support is enabled (hint: required support since 2006-06-06)."
  default     = "disable"
}

variable "namespace" {
  type        = "string"
  description = "The namespace for this module."
  default     = "myname"
}

variable "shared_accounts" {
  type        = "list"
  description = "List of accounts to share gateways"

  default = [
    "000000000000",
  ] // some account
}

variable "spoke_type" {
  type        = "string"
  description = "The type of environment this spoke is. Usually one of shared, engineering or production."
  default     = "shared"
}

variable "subnet_tag_key" {
  type        = "string"
  description = "The key that will be used to find subnets for routing. This terraform currently assumes 3 subnet AZs per VPC"
  default     = "mysubnettag"
}

variable "tag_purpose" {
  type        = "string"
  description = "The value of the purpose tag."
  default     = "mypurpose"
}

variable "vpn_ecmp_support" {
  type        = "string"
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled. One of ENABLE or DISABLE."
  default     = "disable"
}
