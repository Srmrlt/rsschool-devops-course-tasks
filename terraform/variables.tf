variable "aws_region" {
  description = "AWS Region for all resources"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "trusted_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "k3s_instance_type" {
  description = "EC2 instance type for the k3s host"
  type        = string
  default     = "t3.medium"
}

variable "bastion_ssh_key" {
  description = "Public Key Pair to use for SSH access to bastion"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2NJ8Rx3VBJpW2vPk6g+2XkLm2LcnBfLbCNO7GMScdw"
}

variable "k3s_ssh_key" {
  description = "Public Key Pair to use for SSH access to k3s"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlqCA/c3nRaYQs5IIellabMs5aqX7RhRfcv2AqPYN9h bastion"
}
