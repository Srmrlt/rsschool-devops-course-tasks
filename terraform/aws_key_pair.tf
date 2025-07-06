resource "aws_key_pair" "bastion" {
  key_name   = "bastion_ssh_key"
  public_key = var.bastion_ssh_key
}

resource "aws_key_pair" "k3s" {
  key_name   = "k3s_ssh_key"
  public_key = var.k3s_ssh_key
}
