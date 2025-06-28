locals {
  ami_catalog = {
    amazon_linux_2023 = "ami-0229b8f55e5178b65"
    ubuntu_22_04      = "ami-02003f9f0fde924ea"
  }
}

resource "aws_instance" "bastion" {
  ami                         = local.ami_catalog.ubuntu_22_04
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "k3s" {
  ami           = local.ami_catalog.ubuntu_22_04
  instance_type = var.bastion_instance_type
  for_each      = aws_subnet.private
  subnet_id     = each.value.id
  key_name      = aws_key_pair.k3s.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = {
    Name = "k3s-${each.key}"
  }
}
