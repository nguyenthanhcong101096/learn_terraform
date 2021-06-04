resource "aws_instance" "ec2_instances" {
  count                  = length(var.public_subnets)
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnets[count.index].id
  vpc_security_group_ids = [var.sg_public_id]
 
  root_block_device {
    volume_size           = var.instance_vol_size
    volume_type           = var.instance_vol_type
    delete_on_termination = var.instance_vol_del_on_term
  }
}
