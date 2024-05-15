variable "vpc_cidr" {
  description = "CIDR Virginia"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets publicas"
  type        = map(map(string))
}

variable "private_subnets" {
  description = "Lista de subnets privadas"
  type        = map(map(string))
}

variable "sufix" {
  description = "Sufijo para descripciones"
  type        = string
}

variable "natgw" {
  description = "Enable/Disable natgw"
  type        = bool
  default     = false
}

variable "s3_endpoint_enable" {
  description = "Enable/Disable s3 endpoint"
  type        = bool
  default     = false
}

variable "dynamodb_endpoint_enable" {
  description = "Enable/Disable dynamodb endpoint"
  type        = bool
  default     = false
}

variable "dns_support" {
  description = "Enable vpc dns support"
  type        = bool
}

variable "dns_hostnames" {
  description = "Enable vpc hostname"
  type        = bool
}





