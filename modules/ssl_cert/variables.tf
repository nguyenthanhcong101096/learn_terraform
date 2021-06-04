variable "dns_domain" {
  default = "reviewphim.today"
}

variable "aws_alb" {
  type = any
}

variable "request_certificates" {
  type    = list
  default = ["www.reviewphim.today", "hi.reviewphim.today"]
}
