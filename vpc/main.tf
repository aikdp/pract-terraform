#1. VPC
# 2. SUBNETS --Pub, Private, DB
# 3. IGW
# 4. EIP
# 5. NGW
# 6. routetables--pub, private, db
# routes--
# 7. routetable assos with pub subnet, prv, db subnet
# routetabke assos with NGW--private, db

#1, VPC
resource "aws_vpc" "main" {
  cidr_block       = var.my_vpc_cidr
  enable_dns_support = true # default is true
  enable_dns_hostnames = true   # boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.

  tags = merge(
    var.common_tags,
      {
        Name = local.module_name
      }
  )
}


#2. Subnets-public
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true    #assigned a public IP address, Default is false
  availability_zone = local.az_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${local.module_name}-public-${local.az_zones[count.index]}" #expense-dev-public-us-east-1a, 1b
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${local.module_name}-private-${local.az_zones[count.index]}" #expense-dev-private-us-east-1a, 1b
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]

  tags = merge(
    var.common_tags,  
    {
      Name = "${local.module_name}-database-${local.az_zones[count.index]}" #expense-dev-database-us-east-1a, 1b
    }
  )
}

#3.Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = local.module_name
    }
  )
}

# 4. Elastic Ip
resource "aws_eip" "nat_eip_1" {
  domain   = "vpc"

  tags = {
    Name = "${local.module_name}-eip-1"
  }
}

#5. Nat gateway
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public[0].id #here one nat gw creating, if you 2, create EIP and NGW one more

  tags = {
    Name = "${local.module_name}-NAT1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#  Elastic Ip-2
resource "aws_eip" "nat_eip_2" {
  domain   = "vpc"

  tags = {
    Name = "${local.module_name}-eip-2"
  }
}

#. Nat gateway-2
resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public[1].id #here one nat gw creating, if you 2, create EIP and NGW one more

  tags = {
    Name = "${local.module_name}-NAT2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_nat_gateway.nat_gw_1]
}

#6. Route Tables; one Rt suffiecmt for two or more AZ, IGW is VPC level
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"  #for outside access through IGW--public subnet
  #   gateway_id = aws_internet_gateway.gw.id
  # }

  tags = {
    Name = "${local.module_name}-rtb"
  }
}

#RT--Private: TWO RT id needed for HA for multi- AZ
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0" #for outside access through NGW-- put it in public subnet(apps to get patches or dependecies dowload)
  #   nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  # }

  tags = {
    Name = "${local.module_name}-prvt-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0" #for outside access through NGW-- put it in public subnet(apps to get patches or dependecies dowload)
  #   nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  # }

  tags = {
    Name = "${local.module_name}-rtb-prvt_2"
  }
}

#RT--DATABASE: 
resource "aws_route_table" "database_1" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0" #for outside access through NGW-- put it in public subnet
  #   nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  # }

  tags = {
    Name = "${local.module_name}-rtb-db_1"
  }
}
resource "aws_route_table" "database_2" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0" #for outside access through NGW-- put it in public subnet
  #   nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  # }

  tags = {
    Name = "${local.module_name}-rtb-db_2"
  }
}


#Craete routes seperates-->Public, I have created only one Public route table
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#Craete routes seperates-->Priavte_1 #Here prv and Db two route table created due to I have created 2 NAT GWs
resource "aws_route" "private_1" {
  route_table_id            = aws_route_table.private_1.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_1.id
}
#Craete routes seperates-->Priavte_1
resource "aws_route" "private_2" {
  route_table_id            = aws_route_table.private_2.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_2.id
}

#Craete routes seperates-->DB_1
resource "aws_route" "db_1" {
  route_table_id            = aws_route_table.database_1.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_1.id
}
#Craete routes seperates-->DB_2
resource "aws_route" "db_2" {
  route_table_id            = aws_route_table.database_2.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_2.id
}

#7. Route Table association
# resource "aws_route_table_association" "public_1" {
#   subnet_id      = aws_subnet.public[0].id
#   route_table_id = aws_route_table.public.id
#   gateway_id     = aws_internet_gateway.gw.id
# }
# resource "aws_route_table_association" "public_2" {
#   subnet_id      = aws_subnet.public[1].id
#   route_table_id = aws_route_table.public.id
#   gateway_id     = aws_internet_gateway.gw.id
# }
#Count--public subnet assoc
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public[*])
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#Count--private subnet assoc
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private_1.id
}
resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private_2.id
}

#Count--private subnet assoc
resource "aws_route_table_association" "database_1" {
  subnet_id      = aws_subnet.database[0].id
  route_table_id = aws_route_table.database_1.id
}
resource "aws_route_table_association" "database_2" {
  subnet_id      = aws_subnet.database[1].id
  route_table_id = aws_route_table.database_2.id
}
