provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  tags = {
    name = "czarekec2"
  }
  key_name = "czarek_aws"
  
  metadata_options {
    http_tokens = "required"
  } 


  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }
}