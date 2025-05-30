provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


resource "aws_instance" "demo" {
  ami           = "ami-0953476d60561c955"  # Ubuntu 20.04 in us-east-1
  instance_type = "t2.micro"
  key_name      = "tf-jen"

  tags = {
    Name = "jenkins-ec2"
  }
}

output "public_ip" {
  value = aws_instance.demo.public_ip
}
