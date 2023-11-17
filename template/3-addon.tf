module "eks_blueprints_addon" {
  source  = "aws-ia/eks-blueprints-addon/aws"
  version = "~> 1.1"
  count   = 0

  chart         = "actions-runner-controller"
  chart_version = "0.23.3"
  repository    = "https://actions-runner-controller.github.io/actions-runner-controller"
  namespace     = "actions-runner-controller"

  # IAM role for service account (IRSA)
  create_role   = true
  create_policy = true
  role_name     = "actions-runner-controller"
  policy_name   = "actions-runner-controller"
  policy_statements = [
    {
      "Effect" : "Allow",
      "Action" : [
        "ecr:GetAuthorizationToken"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource" : [
        "*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "kms:Decrypt",
        "kms:Encrypt"
      ],
      "Resource" : "*"
    },
    {
      "Action"   = "eks:Describe*"
      "Effect"   = "Allow"
      "Resource" = "*"
    }
  ]
  set_irsa_names = ["serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"]

  oidc_providers = {
    this = {
      provider_arn    = module.eks.oidc_provider_arn
      namespace       = "actions-runner-controller"
      service_account = "github-action-runner"
    }
  }
}