variable "my_vpc_cidr"{
  default = "10.0.0.0/16"
}

variable "project" {
    default = "expense"
}

variable "environment"{
    default = "dev"
}

variable "common_tags"{
  default = {
    Project = "devops"
    Environment = "dev"
    Module = "vpc"
    Terraform = "true"
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        =list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
  description = "Private subnet CIDRs"
}

variable "database_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
  description = "Database subnet CIDRs"
}

variable "peer_owner_id"{ 
  default = "537124943253"
}

variable "peering_connection_required_or_not"{
  default = true
}

# variable "peer_region"{
#   default = "us-east-1"
# }