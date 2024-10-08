resource "aws_security_group" "db" {
  vpc_id = var.vpc_id
  name   = "${local.name_prefix}-db"

  ingress {
    description = "Allow MySQL Inbound From the VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    Name = "${local.name_prefix}-db"
  })
}
