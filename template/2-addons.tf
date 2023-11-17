module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.11"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

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
  enable_karpenter             = false

  enable_external_dns            = true
  external_dns_route53_zone_arns = [data.aws_route53_zone.aws_pepo_dev.arn]

  enable_cert_manager                   = true
  cert_manager_route53_hosted_zone_arns = [data.aws_route53_zone.aws_pepo_dev.arn]

  # enable_external_secrets                = true
  # enable_velero                          = true
  # enable_gatekeeper                      = true
  # enable_aws_efs_csi_driver              = true
  # enable_aws_cloudwatch_metrics          = true
  # enable_argo_events                     = true
  # enable_argo_rollouts                   = true
  # enable_argo_workflows                  = true
  # enable_cluster_autoscaler              = true
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

    just-nginx = {
      description      = "A Helm chart for Just Nginx"
      namespace        = "just-nginx"
      create_namespace = true
      chart            = "onechart"
      chart_version    = "0.60.0"
      repository       = "https://chart.onechart.dev"
      values = [
        <<-EOT
            image:
              repository: nginx
              tag: latest
            replicas: 2
            ingress:
              ingressClassName: nginx
              annotations:
                cert-manager.io/cluster-issuer: letsencrypt
              host: hashitalk.${data.aws_route53_zone.aws_pepo_dev.name}
              tlsEnabled: true
          EOT
      ]
    }
  }
}