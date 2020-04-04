# vpc_id = "vpc-0f520c281e8f715a7"
# subnet_ids = ["subnet-0be6132f476b61619", "subnet-0907e091d357291c0", "subnet-0a5131583e55a10ef" ]
route53_zone ="servian-sg.gradeous.io"
lb_name = "servian-vault-nlb"
lb_type = "network"
vault_cluster_name="vault-example"
acm_domain="vault.servian-sg.gradeous.io"
environment="servian-vault"
# Terraform doesn't supprt allocationg internal ip to ALB/NLB at the moment.
# It is an open PR request which should be released in the next version
# https://github.com/terraform-providers/terraform-provider-aws/pull/11404
# subnet_mapping = [
#   {
#     "subnet_id": "subnet-0be6132f476b61619",
#     "private_ip": "10.195.55.49"
#   },
#   {
#     "subnet_id": "subnet-0907e091d357291c0",
#     "private_ip": "10.195.55.70"
#   },
#   {
#     "subnet_id": "subnet-0a5131583e55a10ef",
#     "private_ip": "10.195.55.118"
#   }
# ]
