# VPC
1. updating the same route tables again and again even when no real changes are happening, and this usually happens because of how Terraform detects changes in nested blocks like route.
2. You're defining route blocks inside aws_route_table, and when Terraform plans, it detects a difference in ordering or implicit values (like null, "", or attributes AWS doesn't return) — even though logically the config hasn't changed.
```
  - route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "nat-xxx"
  }
  + route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "nat-xxx"
  }
```
3. But Terraform internally compares the "old" route block to the "new" one and detects it needs to replace it, which causes constant updates.
4. Instead of defining routes inside aws_route_table, define them outside as separate resources:
```
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
```
5. This way, Terraform can track each route explicitly and avoid repeated changes to the aws_route_table resource.

---
Use lifecycle block to ignore changes (not ideal):

1. If you really want to keep routes inline, you can do this (not recommended for long-term use):
```
resource "aws_route_table" "public" {
  ...

  lifecycle {
    ignore_changes = [route]
  }
}
```
2. Drawback: Terraform will stop managing your routes, meaning future changes to them will not be applied or removed — risky for infrastructure updates.