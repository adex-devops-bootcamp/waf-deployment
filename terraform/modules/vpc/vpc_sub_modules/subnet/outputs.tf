output "subnet_ids" {
  description = "List of subnet IDs created by this module"
  value       = aws_subnet.subnet[*].id
}

output "aws_route_table_id" {
    description = "Route table id"
    value = aws_route_table.route_table[*].id
}
