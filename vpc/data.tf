#For application HA, We need Availability Zones. 
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_vpc" "default" {
  state = "available"
  default = true
    filter {
        name   = "cidr-block"
        values = ["172.31.0.0/16"]
    }
}

data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
#   filter {
#     name   = "association.main"
#     values = ["true"]
#   }
}
