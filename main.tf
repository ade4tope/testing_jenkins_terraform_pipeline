module "networking" {
  source   = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  tags     = local.tags
}


module "security_group" {
  source = "./modules/security_groups"
  vpc_id = module.networking.vpc_id
  tags   = local.tags
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_version = "1.21"
  cluster_name    = "tope-cluster"
  vpc_id          = module.networking.vpc_id
  subnets         = [aws_subnet.PrivateSubnet-1.id, aws_subnet.PrivateSubnet-2.id]

  worker_groups = [
    {
      instance_type = "m5.large"
      asg_desired_capacity = 2
      asg_max_size  = 2
    }
  ]
}

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 18.0"

#   cluster_name    = "my-cluster"
#   cluster_version = "1.21"

#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   cluster_addons = {
#     coredns = {
#       resolve_conflicts = "OVERWRITE"
#     }
#     kube-proxy = {}
#     vpc-cni = {
#       resolve_conflicts = "OVERWRITE"
#     }
#   }

#   # cluster_encryption_config = [{
#   #   provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
#   #   resources        = ["secrets"]
#   # }]

#   vpc_id     = " module.networking.vpc_id"
#   subnet_ids = ["aws_subnet.PrivateSubnet-1.id", "aws_subnet.PrivateSubnet-2.id"]

#   eks_managed_node_group_defaults = {
#     disk_size      = 50
#     instance_types = ["m5.large"]
#   }

#   eks_managed_node_groups = {
#     blue = {}
#     green = {
#       min_size     = 1
#       max_size     = 10
#       desired_size = 1

#       # instance_types = ["t3.large"]
#       # capacity_type  = "SPOT"
#     }
#   }
# }