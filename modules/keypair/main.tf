resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = "echo '${self.private_key_pem}' > ./key.pem"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = tls_private_key.pk.public_key_openssh
}
