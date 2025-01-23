provider "aws" {
  region = var.aws_location
}

# variable "instance_ami" {
#   description = "EC2 instance ami"
#   type        = string
#   default     = "ami-0182f373e66f89c85"
# }

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "aws_location" {
  description = "AWS location"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_availability_zone" {
  description = "Subnet Availablity Zone"
  type        = string
  default     = "us-east-2a"
}


variable "aws_vpc1_cidr" {
  description = "AWS VPC1 CIDR"
  default     = "10.0.0.0/16"
}
variable "aws_vpc2_cidr" {
  description = "AWS VPC2 CIDR"
  default     = "10.10.0.0/16"
}