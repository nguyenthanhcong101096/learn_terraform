variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type"
}

variable "instance_name" {
  default = "ec2_ubuntu"
}

variable "instance_ami" {
  default = "ami-01eadf33e58113fa2"
}

variable "instance_vol_type" {
  default = "gp2"
}

variable "instance_vol_size" {
  default = "30"
}

variable "instance_vol_del_on_term" {
  default = "true"
}

variable key_name {
  type = string
}

variable public_subnets {
  type = any
}

variable sg_public_id {
  type = any
}

variable "instance_profile" {
  type = any
}

variable "cluster_name" {
  type = any
}
