variable "project_tags" {
  description = "tags del proyecto"
  type = object({
    env         = string
    owner       = string
    cloud       = string
    project     = string
    region      = string
    region-code = string
  })
}

variable "vpc" {
  description = "Valores de la VPC"
  type = object({
    cidr                     = string
    public_subnets           = map(map(string))
    private_subnets          = map(map(string))
    natgw_enable             = bool
    dns_support              = bool
    dns_hostnames            = bool
    s3_endpoint_enable       = bool
    dynamodb_endpoint_enable = bool
  })
}



########### EKS ###########

variable "eks-poc" {
  description = "Valores del EKS"
  type = object({
    name                                     = string
    version                                  = string
    cluster_endpoint_public_access           = bool
    cluster_endpoint_private_access          = bool
    cluster_addons                           = map(map(any))
    create_cluster_security_group            = bool
    create_node_security_group               = bool
    enable_cluster_creator_admin_permissions = bool
    access_entries                           = any
    fargate_profiles                         = any
    eks_managed_node_groups                  = any
  })
}


