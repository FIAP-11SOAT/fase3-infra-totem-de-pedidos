resource "random_password" "rds_password" {
  length  = 16
  special = true
  override_special = "!@#$%^&*"
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "${local.projetc_name}-rds-postgres"

  engine               = "postgres"
  engine_version       = "17.5"
  family               = "postgres17"
  major_engine_version = "17"
  instance_class       = "db.t4g.micro"
  allocated_storage    = 20

  db_name  = "infra_totem_de_pedidos_database"
  username = "infra_totem_de_pedidos_admin"
  password = random_password.rds_password.result
  manage_master_user_password = false

  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "${local.projetc_name}-rds-postgres"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${local.projetc_name}-rds-postgres-subnet-group"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "${local.projetc_name}-rds-postgres-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "${local.projetc_name}-rds-postgres-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Acesso externo ao PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.projetc_name}-rds-postgres-sg"
  }
}