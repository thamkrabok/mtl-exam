terraform {
    source  = "tfr:///aws-ia/eks-blueprints-addon/aws//.?version=1.1.1"
}

// generate "kubernetes" {
//   path      = "kubernetes.tf"
//   if_exists = "overwrite_terragrunt"
//   contents = <<EOF
// provider "kubernetes" {
//     config_path = "C:\\Users\\USER\\.kube\\config"
// }
// EOF
// }

include "root" {
    path = "${find_in_parent_folders()}"
}

inputs = {
  chart         = "helm-hello"
  chart_version = "0.1.0"
  repository    = "https://thamkrabok.github.io/mtl-exam/helm/helm-hello/charts/"
  namespace     = "helm-hello"

  # IAM role for service account (IRSA)
  create_role   = true
  create_policy = true
  role_name     = "helm-hello"
  policy_name   = "helm-hello"
  policy_statements = [
    {
      "Effect" : "Allow",
      "Action" : [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource" : "arn:aws:s3:::my-web-assets/*" 
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
      ],
      "Resource" :  "arn:aws:sqs:ap-southeast-1:123456789123:lms-import-data" 
    },
  ]
  set_irsa_names = ["serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"]

  oidc_providers = {
    this = {
      provider_arn    = dependency.eks.outputs.oidc_provider_arn
      namespace       = "helm-hello"
      service_account = "helm-hello"
    }
  }
}

dependency "eks" {
  config_path = "../1-eks"
  mock_outputs = {
    cluster_name      = "mock-eks-cluster"
    cluster_version   = "1.27"
    cluster_endpoint  = "mock-eks-cluster-endpoint"
    cluster_subnet_ids = [
      "mock-subnet-id-1",
      "mock-subnet-id-2",
      "mock-subnet-id-3",
    ]
    node_group_desired_capacity = 1
    node_group_min_capacity     = 1
    node_group_max_capacity     = 2
    node_group_instance_types   = ["t3.micro"]
    node_group_capacity_type    = "SPOT"
    cluster_arn                 = "arn:aws:eks:ap-southeast-1:123456789123:cluster/mock-eks-cluster"
    oidc_provider_arn           = "arn:aws:iam::123456789123:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/mock-eks-cluster"
  }
}

