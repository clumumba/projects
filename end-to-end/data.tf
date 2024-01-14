# data "terraform_remote_state" "network" {
#   backend = "local"
#   config = {
#     path = "../vpc/terraform.tfstate"
#   }
# }
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Specify your desired availability zone
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVZQHS9XiCartYJyJAcSpjZqvBg4osFpJWLVJs3stNDsN7j+XDPEdzW5wrsN1VB5xHbv4Hrgwe80gKtAGcM1+Dpm88FroMBKZ6as7EKVz41lJ2yMwtKeLZKQ/Sw/K1DbEdbxSjd/ETDXnPvqYNN4LM1nTkRyJRb/K+DXkE1VyS2frF98FRhrbSl7RrjrYoGI2eDKmFgY6oiT1jVSjzqp2kkkogYaNYULMdYQAksIq131crlk5KaIP81Rj22L8w6z8RF05UdUFdmW8QMMyaFFKvDbjofSc/bQy19WFFwknLad9VqUvNatsuyJh6BnUdmYmU+meCIn2vvjOXI/xazpbrncB4q1TAlmlOnkoqAOOuqi6ejH7sh8nY1FQQoTbBybjigKHcDIBpYE+Q/LTsqcUIaG3rFgmPbFHkuGJcz/Azit67S7XIHATgQcnqYa6adK50FJ+eMan49OnacNGDG6T1CQme3xwmbFItR/oKWNJ9nCNtN9TZ/rR7707FGrfvt4YrCpBj4wpXrZBPkhLgH0AbmGaHVh+anbsC6LwJgcaYWY4XDP0QAVzEWFbKBqPmjkqyJ3uQaCOKGmWp3TQkK2FCQNpc0RE6oGxZE4J3xpSjTNU3xfFrky+Wgt6YGwsGsqo0sFYtoQ0xpOE5ZBg0kB9PQrsizcRWHqO2fxch0Acqgw== CERSIDY OKEYO@Okeyo"
  # Specify the path to your public key
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-0005e0cfe09cc9050" # Specify your AMI ID
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key_pair.key_name
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyEC2Instance"
  }
}