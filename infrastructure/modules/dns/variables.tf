variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "lb_dns_name" {
  description = "LB DNS Name"
  type        = string
}

variable "lb_zone_id" {
  description = "LB Zone ID"
  type        = string
}

variable "cert_validation_resource_record_name" {
  description = "Resource Record Name"
  type        = string
}

variable "cert_validation_resource_records" {
  description = "Resource Records"
  type        = list(string)
}

variable "cert_validation_resource_record_type" {
  description = "Resource Record Type"
  type        = string
}

variable "cert_arn" {
  description = "Cert ARN"
  type        = string
}

variable "lb_sg_id" {
  description = "SG of Loadbalancer"
  type        = string
}

variable "listener_arn" {
  description = "Loadbalancer TLS Listner ARN"
  type        = string
}