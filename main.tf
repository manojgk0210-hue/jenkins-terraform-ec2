provider "aws" {
  region     = "ap-south-1"
  access_key = "Add you access_key"
  secret_key = "add you secret-key"
}
variable "key_name" {
  default = "manoj"
}

variable "instance_type" {
  default = "t2.medium"
}

# Generate random suffix to avoid duplicate SG error
resource "random_id" "suffix" {
  byte_length = 3
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group (unique name every run)
resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg-${random_id.suffix.hex}"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = file("jenkins-install.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "Jenkins-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server.public_ip}:8080"
}
