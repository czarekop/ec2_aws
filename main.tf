provider "aws" {
  region = "eu-central-1"
}

variable "ec2_Instance_Name" {
  type    = string
}

resource "aws_instance" "ec2" {
  ami           = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"
  tags = {
    name = var.ec2_Instance_Name
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