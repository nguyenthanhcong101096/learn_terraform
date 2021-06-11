variable "env" {
  default = "development"
}

variable "app" {
  default = "congnt"
}

variable db_engine {
  default = "mysql"
}

variable db_version {
  default = "5.7"
}

variable db_instance_class {
  default = "db.t2.micro"
}

variable private_subnets {
  type = any
}

variable rds_security_group {
  type = any
}
