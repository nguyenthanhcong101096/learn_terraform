resource "aws_alb" "elb" {
  name                = "ecs-load-balancer"
  security_groups     = [var.sg_public_id]
  subnets             = var.public_subnets.*.id

  tags = {
    Name = "project_name_elb"
  }
}

resource "aws_alb_target_group" "http_target_group" {
    port     = "80"
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
      Name = "http_target_group"
    }
}


resource "aws_alb_target_group" "https_target_group" {
    port     = "443"
    protocol = "HTTPS"
    vpc_id   = var.vpc_id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTPS"
        timeout             = "5"
    }

    tags = {
      Name = "https_target_group"
    }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.http_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.elb.arn
  certificate_arn   = var.certificate_arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_alb_target_group.http_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "svc_physical_external_http" {
  count            = length(var.ec2_instances)
  port             = 80
  target_group_arn = aws_alb_target_group.http_target_group.arn
  target_id        = var.ec2_instances[count.index].id
}

resource "aws_alb_target_group_attachment" "svc_physical_external_https" {
  count            = length(var.ec2_instances)
  port             = 443
  target_group_arn = aws_alb_target_group.https_target_group.arn
  target_id        = var.ec2_instances[count.index].id
}
