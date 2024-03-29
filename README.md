## MTL Assignment ##
**Task:**
 - 1 Create a Dockerfile for a given application
    -   You can check Dockerfile in this repo.

 - 2 Build the image using the Dockerfile and push to Docker Hub
    - thamkrabok/docker-hello:1.0

 - 3 Create a Helm Chart to deploy the image from the previous step. The chart should have
flexibility to allow Developer to adjust Values without having to rebuild the chart
frequently
    - You can check my helm chart in /helm/helm-hello on this repo. 
    - I have already created Github Page and push helm packages to this repo "https://thamkrabok.github.io/mtl-exam/helm/helm-hello/charts/"

 - 4 Setup EKS cluster with the related resources to run EKS like VPC, Subnets, etc. by following EKS Best Practices using any IaC tools (Bonus point: use
Terraform/Terragrunt)
    - I have already craeted IaC Code for terraform modules and terragrunt.
        - Terraform: You can check my terraform file in /terraform-eks-blueprints on this repo.       
        - Terragrunt: You can check my terragrunt files and structures in /eks-blueprints on this repo.
        - Both of them using S3 bucket and DynamoDB to collect .tfstate file.
        - Both of them can create VPC, Subnet, Nat Gateway, and EKS Cluster.
        - Both of them can deploy pre-define dependencies from modules eks_blueprints_addons.
        - Both of them will be deploy ArgoCD and Karpenter immidiately after you run `terraform apply` or `terragrunt apply`.
        - Both of them have file for deploy app from my helm charts but it still didn't work. 

 - 5 When the sample application deploys to EKS, they need to have access to

    5.1 S3 with permission GetObject, PutObject (S3 ARN:arn:aws:s3:::my-web-assets)
    
    5.2 SQS with permission; send, receive, delete message (SQS ARN:arn:aws:sqs:ap-southeast-1:123456789123:lms-import-data)
    
    5.3 Condition: Avoid injecting the generated aws secret/access keys to the
application directly.

    - You can check terraform file and terragrunt file for deploy app in these path on this repo.
        - Terraform: /terraform-eks-blueprints/3-addon.tf
        - Terragrunt: /eks-blueprints/env/dev/2-kube/terragrunt.hcl
        - If you try to run `terraform apply` or `terragrunt apply` to deploy app from my helm charts you will didn't see anything change from terraform.

 - 6 Use ArgoCD to deploy this application. To follow GitOps practices, we prefer to have an ArgoCD application defined declaratively in a YAML file if possible.
    - You can check terraform file and terragrunt file for deploy ArgoCD and other pre-define dependencies from module "eks_blueprints_addons" in these path on this repo.
        - Terraform: /terraform-eks-blueprints/2-addons.tf
        - Terragrunt: /eks-blueprints/env/dev/3-kubeaddons/terragrunt.hcl
    
    - Use kube forward port for expose port ArgoCD
    `kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443`
    
    - Use this command to get password for access to ArgoCD with admin user.
    `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

 - 7 (Bonus point) Create CICD workflow using Github Actions to build and deploy application
    - **Only Terraform, not for Terragrunt** I have already configured connecting between this repo and TerraformCloud to trigger run terraform init and plan when the pull request occurs and it will be trigger terraform init, plan, and apply when merge another branch to master or main branch.
    - You can see workflow in /.github/workflows/terraform.yml on this repo.

I apologize for the assignment not being successful. I did my best to complete it. 

I spent 4-5 hours working on this assignment and decided to submit it because I won't have available time to complete it after today.

I encountered a challenge for 2-3 hours while attempting to work on this assignment on my Windows machine. Subsequently, I switched to completing the assignment on Linux (SUSE).
