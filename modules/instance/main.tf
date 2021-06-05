resource "aws_instance" "ec2_instances" {
  count                  = length(var.public_subnets)
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnets[count.index].id
  vpc_security_group_ids = [var.sg_public_id]
  iam_instance_profile   = var.instance_profile
  user_data              = <<EOF
                           #!/bin/bash
                           echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
                           EOF
 
  root_block_device {
    volume_size           = var.instance_vol_size
    volume_type           = var.instance_vol_type
    delete_on_termination = var.instance_vol_del_on_term
  }
}
