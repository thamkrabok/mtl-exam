terraform {
    source  = "tfr:///aws-ia/eks-blueprints-addons/aws//.?version=1.12.0"
}

include "root" {
    path = "${find_in_parent_folders()}"
}

inputs = {
  cluster_name      = dependency.eks.outputs.cluster_name
  cluster_endpoint  = dependency.eks.outputs.cluster_endpoint
  cluster_version   = dependency.eks.outputs.cluster_version
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  ## EKS add-ons
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    kube-proxy = {
      most_recent = true
    }
  }

  ## Blueprints add-ons
  enable_argocd                = true
  enable_kube_prometheus_stack = true
  enable_metrics_server        = true
  enable_ingress_nginx         = true
  enable_karpenter             = true

  enable_external_dns            = false
  enable_cert_manager                   = false

  # enable_external_secrets                = true
  # enable_velero                          = true
  # enable_gatekeeper                      = true
  # enable_aws_efs_csi_driver              = true
  # enable_aws_cloudwatch_metrics          = true
  # enable_argo_events                     = true
  # enable_argo_rollouts                   = true
  # enable_argo_workflows                  = true
  enable_cluster_autoscaler              = true
  # enable_cluster_proportional_autoscaler = true

  ## Pass in any number of Helm charts to be created for those that are not natively supported
  helm_releases = {
    prometheus-adapter = {
      description      = "A Helm chart for k8s prometheus adapter"
      namespace        = "prometheus-adapter"
      create_namespace = true
      chart            = "prometheus-adapter"
      chart_version    = "4.2.0"
      repository       = "https://prometheus-community.github.io/helm-charts"
      values = [
        <<-EOT
            replicas: 2
            podDisruptionBudget:
              enabled: true
          EOT
      ]
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
