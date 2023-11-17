terraform {
    source = "tfr:///terraform-aws-modules/vpc/aws//.?version=5.1.2"   
}

include "root" {
    path = "${find_in_parent_folders()}"
}

inputs = {
    name = "mtl-exam"
    cidr = "10.0.0.0/16"

    azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway     = true
    single_nat_gateway     = true
    one_nat_gateway_per_az = false
}