variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_1_id" {
  description = "Private Subenet 1 ID"
  type        = string
}

variable "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  type        = string
}

variable "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  type        = string
}