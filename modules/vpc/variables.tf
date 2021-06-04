variable "public_cidr_blocks" {
  type    = list
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_cidr_blocks" {
  type    = list
  default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "regions" {
  type    = list
  default = ["ap-southeast-1a","ap-southeast-1b"]
}
