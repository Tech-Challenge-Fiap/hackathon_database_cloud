terraform {
  cloud {
    organization = "Hackathon_FIAP_G31"

    workspaces {
      name = "hackathon-db"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_db_subnet_group" "dbsubnet" {
  name = "dbsubnetgroup"
  # only private subnets
  subnet_ids = var.subnets_ids
}

resource "aws_security_group" "fiaphack_db_sg" {
  vpc_id      = data.aws_vpc.vpc.id
  name        = "fiaphack_db_sg"
  description = "Allow all inbound for Postgres"
  # the database is only accessible via private subnets
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "fiaphack_db" {
  identifier             = "fiaphack-db"
  db_name                = "hackdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.fiaphack_db_sg.id]
  username               = var.DB_USER
  password               = var.DB_PASSWORD
  db_subnet_group_name   = aws_db_subnet_group.dbsubnet.name
}
