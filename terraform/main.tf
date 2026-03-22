provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "devops_sg" {
  name = "devops-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux (check latest)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.devops_sg.name]
  key_name      = "your-key"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "DevOps-Server"
  }
}