resource "aws_vpc_peering_connection" "peering_setup" {
  count = var.peering_connection_required_or_not ? 1 : 0
  peer_owner_id = var.peer_owner_id #The AWS account ID of the target peer VPC
  peer_vpc_id   = data.aws_vpc.default.id    #The ID of the target VPC 
  vpc_id        = aws_vpc.main.id   #The ID of the requester VPC
#   peer_region   = var.peer_region
  auto_accept   = true  #when this is true, region not works

   tags = merge(
    var.common_tags,
    {
        Name = "peering-default"
    }
   )
}

resource "aws_route" "default_to_expense_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0    #if not put this lines, TF will parallel executes
#   route_table_id            = data.aws_vpc.default.main_route_table_id
  route_table_id            = data.aws_route_table.main.route_table_id
  destination_cidr_block    = var.my_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}


resource "aws_route" "public_expense_vpc_to_default_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}

resource "aws_route" "private_1_expense_vpc_to_default_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0
  route_table_id            = aws_route_table.private_1.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}

resource "aws_route" "private_2_expense_vpc_to_default_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0
  route_table_id            = aws_route_table.private_2.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}


resource "aws_route" "db_1_expense_vpc_to_default_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0
  route_table_id            = aws_route_table.database_1.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}

resource "aws_route" "db_2_expense_vpc_to_default_vpc" {
  count = var.peering_connection_required_or_not ? 1 : 0
  route_table_id            = aws_route_table.database_2.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_setup[count.index].id
}
