provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami                    = "ami-09298640a92b2d12c"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0f0d833846a75da60"
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.my_key.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:/Users/AG/.ssh/keys/my_key")
  }

  provisioner "remote-exec" {
    inline = [
      "touch happy_learning.txt",
      "echo 'Keep Exploring new Technologies' >> happy_learning.txt"
    ]
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

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9XZ7hnCGYomiHuG41mQvkcxTFuaEKVO0Wn9nNg+oh AG@Atharva"
}