provider "aws" {
  region = var.aws_region
}

module "eks_cluster" {
  source              = "terraform-aws-modules/eks/aws"
  cluster_name        = "mern-crud"
  cluster_version     = var.cluster_version
  subnets             = var.subnets
  vpc_id              = var.vpc_id
  node_groups         = var.node_groups
  manage_aws_auth     = true
}

output "kubeconfig" {
  value = module.eks_cluster.kubeconfig
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}
