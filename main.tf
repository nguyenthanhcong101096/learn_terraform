module "keypair" {
  source = "./modules/keypair"
}

module "vpc" {
  source = "./modules/vpc"
}

module "role" {
  source = "./modules/role"
}

module "ecs" {
  source = "./modules/ecs"
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source             = "./modules/rds"
  rds_security_group = module.security_group.sg_private_id
  private_subnets    = module.vpc.private_subnets.*.id
}

module "ec2_instances" {
  source           = "./modules/instance"
  key_name         = module.keypair.key_name
  public_subnets   = module.vpc.public_subnets
  sg_public_id     = module.security_group.sg_public_id
  instance_profile = module.role.instance_profile
  cluster_name     = module.ecs.cluster_name
}

module "load_balance" {
  source          = "./modules/load_balance"
  sg_public_id    = module.security_group.sg_public_id
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  ec2_instances   = module.ec2_instances.instances
  certificate_arn = module.ssl_cert.certificate_arn
}

module "ssl_cert" {
  source  = "./modules/ssl_cert"
  aws_alb = module.load_balance.elb
}
