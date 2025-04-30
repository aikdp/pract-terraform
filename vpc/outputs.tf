# output "availability_zones" {
#   value       = data.aws_availability_zones.available.names     #names--1a, 1b, 1c, 1d,...  #id--> us-east-1, us-east-2,..
#   description = "Availability zones"
# }

output "default_vpc_check"{
  value = data.aws_vpc.default.main_route_table_id
}

output "default_route_vpc"{
  value = data.aws_route_table.main.route_table_id
}