variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "testing"  # صححت typo
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}