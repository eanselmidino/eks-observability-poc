########### VPC ###########

vpc = {
  "cidr" = "10.110.0.0/16"
  "public_subnets" = {
    public_subnet_a = {
      az   = "us-east-1a"
      cidr = "10.110.0.0/24"
    }
    public_subnet_b = {
      az   = "us-east-1b"
      cidr = "10.110.1.0/24"
    }
    public_subnet_c = {
      az   = "us-east-1c"
      cidr = "10.110.2.0/24"
    }
  }
  "private_subnets" = {
    private_subnet_a = {
      az   = "us-east-1a"
      cidr = "10.110.20.0/24"
    }
    private_subnet_b = {
      az   = "us-east-1b"
      cidr = "10.110.21.0/24"
    }
    private_subnet_c = {
      az   = "us-east-1c"
      cidr = "10.110.22.0/24"
    }
  }
  "natgw_enable"             = true
  "dns_support"              = true
  "dns_hostnames"            = true
  "s3_endpoint_enable"       = true
  "dynamodb_endpoint_enable" = true
}



########### TAGS ###########

project_tags = {
  "env"         = "poc"
  "owner"       = "owner"
  "cloud"       = "AWS"
  "project"     = "observability"
  "region"      = "virginia"
  "region-code" = "us-east-1"
}



########### EKS ###########


eks-poc = {
  name                            = "ekspoc-cloudwatch-poc"
  version                         = "1.29"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  create_cluster_security_group = false
  create_node_security_group    = false


  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "*"
        }
      ]
    }
  }

  enable_cluster_creator_admin_permissions = true
  access_entries                           = {}

  eks_managed_node_groups = {
    eks-node-poc = {
      min_size     = 2
      max_size     = 6
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true

    }
    amazon-cloudwatch-observability = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
}

