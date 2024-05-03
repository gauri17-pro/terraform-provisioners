provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami                    = "ami-09298640a92b2d12c"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0f0d833846a75da60"
  vpc_security_group_ids = [aws_security_group.sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.server.public_ip} >> public_ip.txt"
  }

  tags = {
    Name = "Web-server"
  }
}

resource "aws_security_group" "sg" {
  name   = "my-sg"
  vpc_id = "vpc-08851ab766b4c4824"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}