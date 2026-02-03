resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags = merge (
        { Name = var.name },
        var.tags
    )

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", [])
      description = lookup(ingress.value, "description", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", [])
      description = lookup(egress.value, "description", null)
    }
  }
}
