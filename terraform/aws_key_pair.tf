resource "aws_key_pair" "bastion" {
  key_name   = var.bastion_ssh_key_name
  public_key = file("${path.module}/../ssh-keys/bastion.pub")
}
