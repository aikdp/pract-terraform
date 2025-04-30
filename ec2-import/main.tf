provider "aws" {
    region = "us-east-1"
}

# import {
#     id = "sg-0f487d954cbe820ef"
     
#     to = aws_security_group.devops
# }

resource "aws_instance" "devops_imp" {
  ami                                  = "ami-09c813fb71547fc4f"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1b"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  enable_primary_ipv6                  = null
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = null
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = null
  monitoring                           = false
  placement_group                      = null
  placement_partition_number           = 0
  private_ip                           = "172.31.28.8"
  secondary_private_ips                = []
  security_groups                      = [aws_security_group.devops.id]
  source_dest_check                    = true
  subnet_id                            = "subnet-02571795c888dda45"
  tags = {
    Name = "devops_imp"
  }
  tags_all = {
    Name = "devops_imp"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0f487d954cbe820ef"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
#   cpu_options {
#     amd_sev_snp      = null
#     core_count       = 1
#     threads_per_core = 1
#   }
  credit_specification {
    cpu_credits = "standard"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 20
    volume_type           = "gp3"
  }
}


# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-0f487d954cbe820ef"
resource "aws_security_group" "devops" {
  description = "allowing-all-traffic "
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allowing"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allowing all traffic"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  name                   = "allow-all"
  name_prefix            = null
  revoke_rules_on_delete = null
  tags = {
    Name = "allow-all"
  }
  tags_all = {
    Name = "allow-all"
  }
  vpc_id = "vpc-0af334a7247e5d814"
}
