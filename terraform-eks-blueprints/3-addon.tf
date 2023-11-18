module "eks_blueprints_addon" {
  source  = "aws-ia/eks-blueprints-addon/aws"
  version = "~> 1.1.1"
  count   = 0

 chart         = "helm-hello"
  chart_version = "0.1.0"
  repository    = "https://thamkrabok.github.io/mtl-exam/helm/helm-hello/charts/"
  namespace     = "helm-hello"
  create_namespace = true

  set = [
    {
      name  = "clusterName"
      value = "module.eks.cluster_id"
    },
    {
      name  = "clusterEndpoint"
      value = "moduel.eks.cluster_endpoint"
    },
  ]

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
      provider_arn    =  module.eks.oidc_provider_arn
      namespace       = "helm-hello"
      service_account = "helm-hello"
    }
  }
}
