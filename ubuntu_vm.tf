terraform {
        required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"

}
}
required_version = ">= 1.2.0"
}

provider "aws" {
        region = "ap-southeast-1"
	
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My security group created by Terraform"
  # Ingress rules (inbound traffic rules)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (be cautious with this rule)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere (be cautious with this rule)
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere (be cautious with this rule)
  }


  # Egress rules (outbound traffic rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic (you can restrict this as needed)
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2_instance" {
        ami = "ami-0123c9b6bfb7eb962"
        instance_type = "t2.micro"
        subnet_id     = "subnet-04b14a829790056d0"
        key_name      = "keypair"
	vpc_security_group_ids = [aws_security_group.my_security_group.id]
        associate_public_ip_address = true
	tags = {
                Name = "terraform-server"
}

        ebs_block_device {
                device_name = "/dev/sda1"
                volume_size = 10
                volume_type = "gp3"
  }
}

output "ec2_public_ips" {
  value = aws_instance.my_ec2_instance.public_ip
}
output "ec2_key" {
value = aws_instance.my_ec2_instance.key_name
}
