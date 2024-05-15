terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">=1.5.0"

}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.project_tags
  }
}


provider "kubernetes" {
  host                   = module.eks-poc.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-poc.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks-poc.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks-poc.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-poc.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks-poc.cluster_name]
      command     = "aws"
    }
  }
}


