variable "vpc_name" {
  type = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type = string
  description = "CIDR Block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet cidr"
}
 
variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet cidr"
}
