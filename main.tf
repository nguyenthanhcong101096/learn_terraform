module "keypair" {
  source = "./modules/keypair"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2_instances" {
  source          = "./modules/instance"
  key_name        = module.keypair.key_name
  public_subnets  = module.vpc.public_subnets
  sg_public_id    = module.security_group.sg_public_id
}

module "ssl_cert" {
  source  = "./modules/ssl_cert"
  aws_alb = module.load_balance.elb
}

module "load_balance" {
  source          = "./modules/load_balance"
  sg_public_id    = module.security_group.sg_public_id
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  ec2_instances   = module.ec2_instances.instances
  certificate_arn = module.ssl_cert.certificate_arn
}
