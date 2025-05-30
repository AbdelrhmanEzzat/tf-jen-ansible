provider "aws" {
  region     = "us-east-1"
 
}

resource "aws_instance" "web" {
  ami           = "ami-0953476d60561c955"  # Ubuntu 20.04 in us-east-1
  instance_type = "t2.micro"
  key_name      = "tf-jen"

  tags = {
    Name = "jenkins-ec2"
  }
}
