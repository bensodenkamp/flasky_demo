variable "repo_url" {
  description = "URL of ECR repo"
  type        = string
}

variable "lb_sg_id" {
  description   = "ID of security group for inbound traffic"
  type          = string
}

variable "subnet_1_id" {
  description = "ID of first backed subnet"
  type        = string
}

variable "subnet_2_id" {
  description = "ID of second backend subnet"
  type        = string
}

variable "target_group_id" {
  description = "ID of target group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the vpc"
}