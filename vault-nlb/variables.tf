variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into. Leave an empty string to use the Default VPC in this region."
  type        = string
  default     = null
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "lb_name" {
  type    = string
  default = null
}

variable "lb_type" {
  type    = string
  default = "network"
}

variable "acm_domain" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = ""
}

variable "subnet_mapping" {
  description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
  type        = list(map(string))
  default     = []
}

variable "route53_zone" {
  default = ""
}
