terraform {
    source  = "tfr:///terraform-aws-modules/eks/aws//.?version=19.15.3"
}

include "root" {
    path = "${find_in_parent_folders()}"
}

inputs = {
    cluster_name                   = "mtl-exam"
    cluster_version                = "1.27"
    cluster_endpoint_public_access = true

    vpc_id     = dependency.vpc.outputs.vpc_id
    subnet_ids = dependency.vpc.outputs.private_subnets

    eks_managed_node_groups = {
        default = {
        min_size     = 1
        max_size     = 2
        desired_size = 1

        instance_types = ["t3.micro"]
        capacity_type  = "SPOT"
        }
    }

    manage_aws_auth_configmap = true
    aws_auth_roles            = []
    aws_auth_users            = []
}

dependency "vpc" {
  config_path = "../0-vpc"
  mock_outputs = {
    vpc_id = "vpc-00000000"
    private_subnets = [
      "subnet-00000000",
      "subnet-00000001",
      "subnet-00000002",
    ]
  }
}

