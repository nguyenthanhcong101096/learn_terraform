output "sg_public_id" {
  value = aws_security_group.public_security_group.id
}

output "sg_private_id" {
  value = aws_security_group.private_security_group.id
}
