provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source  = "../modules/ecr"
}

module "flasky_vpc" {
  source  = "../modules/vpc"
  aws_region = var.aws_region
}

module "flasky_nat_gateway" {
    source      =   "../modules/nat_gateway"

    aws_region            = var.aws_region
    vpc_id                = module.flasky_vpc.vpc_id
    private_subnet_1_id   = module.flasky_vpc.private_subnet_1_id
    private_subnet_2_id   = module.flasky_vpc.private_subnet_2_id
    public_subnet_1_id    = module.flasky_vpc.public_subnet_1_id
    public_subnet_2_id    = module.flasky_vpc.public_subnet_2_id
}

resource "aws_acm_certificate" "flasky_cert" {
  domain_name       = "vaxfaxx.com"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

module "flasky_loadbalancer" {
    source              = "../modules/loadbalancer"
    cert_arn            = aws_acm_certificate.flasky_cert.arn
    aws_region          = var.aws_region
    vpc_id              = module.flasky_vpc.vpc_id
    private_subnet_1_id = module.flasky_vpc.private_subnet_1_id
    private_subnet_2_id = module.flasky_vpc.private_subnet_2_id
    public_subnet_1_id    = module.flasky_vpc.public_subnet_1_id
    public_subnet_2_id    = module.flasky_vpc.public_subnet_2_id
}

module "dns" {

  source = "../modules/dns"

  vpc_id              = module.flasky_vpc.vpc_id
  aws_region          = var.aws_region
  domain              = "vaxfaxx.com"
  listener_arn        = module.flasky_loadbalancer.listener_arn
  lb_dns_name         = module.flasky_loadbalancer.lb_dns_name
  lb_zone_id          = module.flasky_loadbalancer.lb_zone_id
  lb_sg_id            = module.flasky_loadbalancer.lb_sg_id

  cert_validation_resource_record_name = tolist(aws_acm_certificate.flasky_cert.domain_validation_options)[0].resource_record_name
  cert_validation_resource_records     = [ tolist(aws_acm_certificate.flasky_cert.domain_validation_options)[0].resource_record_value ]
  cert_validation_resource_record_type = tolist(aws_acm_certificate.flasky_cert.domain_validation_options)[0].resource_record_type
  cert_arn                             = aws_acm_certificate.flasky_cert.arn
}

module ecs {
  vpc_id              = module.flasky_vpc.vpc_id
  source          = "../modules/ecs"
  repo_url        = module.ecr.repo_url
  lb_sg_id       = module.flasky_loadbalancer.lb_sg_id
  subnet_1_id     = module.flasky_vpc.private_subnet_1_id
  subnet_2_id     = module.flasky_vpc.private_subnet_2_id
  target_group_id = module.flasky_loadbalancer.lb_target_group_id
}