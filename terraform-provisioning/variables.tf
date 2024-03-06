variable "aws_region" {
  description = "AWS region"
}

variable "cluster_version" {
  description = "EKS cluster version"
}

variable "subnets" {
  description = "Subnet IDs for EKS"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for EKS"
}

variable "node_groups" {
  description = "EKS node groups"
  type        = list(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_type    = string
    key_name         = string
  }))
}
