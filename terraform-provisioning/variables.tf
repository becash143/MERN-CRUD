variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  // Update with your desired AWS region
}

variable "cluster_version" {
  description = "EKS cluster version"
  default     = "1.27"  // Update with your desired EKS cluster version
}

variable "subnets" {
  description = "Subnet IDs for EKS"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]  // Update with your subnet IDs
}

variable "vpc_id" {
  description = "VPC ID for EKS"
  default     = "vpc-12345678"  // Update with your VPC ID
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
  default = [
    {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = "your-keypair-name"  // Update with your key pair name
    }
  ]
}
