module "vpc" {
  source                   = "./modules/vpc"
  sufix                    = local.sufix
  vpc_cidr                 = var.vpc.cidr
  public_subnets           = var.vpc.public_subnets
  private_subnets          = var.vpc.private_subnets
  dns_support              = var.vpc.dns_support
  dns_hostnames            = var.vpc.dns_hostnames
  natgw                    = var.vpc.natgw_enable
  s3_endpoint_enable       = var.vpc.s3_endpoint_enable
  dynamodb_endpoint_enable = var.vpc.dynamodb_endpoint_enable
}
