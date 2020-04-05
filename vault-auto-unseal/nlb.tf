provider "aws" {
  version = "~> 2.0"
  region  = "ap-southeast-2"
}

data "aws_acm_certificate" "vault" {
  domain   = var.acm_domain
  types    = ["AMAZON_ISSUED"]
}

data "aws_autoscaling_groups" "vault" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = [var.vault_cluster_name]
  }
  depends_on = [module.vault_cluster]
}

# It is for ALB only
# data "aws_security_groups" "vault" {
#   filter {
#     name = "group-name"
#     values = ["${var.vault_cluster_name}*"]
#   }
#
#   filter {
#     name = "vpc-id"
#     values = [var.vpc_id]
#   }
# }

module "nlb" {
  source = "../modules/vault-lb"

  name     = var.lb_name
  internal = false
  load_balancer_type = var.lb_type

  vpc_id  = data.aws_vpc.default.id
  subnets = data.aws_subnet_ids.default.ids
  # security_groups = data.aws_security_groups.vault.ids

  # access_logs = {
  #   bucket = "my-nlb-logs"
  # }

  subnet_mapping = var.subnet_mapping

  target_groups = [
    {
      name_prefix      = "vault-api"
      backend_protocol = "TCP"
      backend_port     = 8200
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = data.aws_acm_certificate.vault.arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 8200
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = var.environment
  }

}

# DNS R53
data "aws_route53_zone" "default" {
  name = var.route53_zone
  private_zone = false
}

# PTFE point CNAME Record to PTFE Load balancer
resource "aws_route53_record" "vault_cname_records" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "vault"
  type    = "CNAME"
  ttl     = "300"
  records = [module.nlb.this_lb_dns_name]
}

# Create a new NLB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_vault_api" {
  autoscaling_group_name = element(data.aws_autoscaling_groups.vault.names, 0)
  alb_target_group_arn   = element(module.nlb.target_group_arns,0)
}
