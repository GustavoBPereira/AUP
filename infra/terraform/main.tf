terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

# Create a random password for the database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Store the password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "aup-database-password"
  description = "Database password for AUP PostgreSQL instance"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

resource "aws_db_instance" "aup_postgres" {
  identifier           = "aup-postgres"
  engine              = "postgres"
  engine_version      = "17.2"  # Updated to a supported version
  instance_class      = "db.t3.micro"  # Free tier eligible
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = "aupdb"
  username            = "aupadmin"
  password            = random_password.db_password.result
  
  skip_final_snapshot = true
  publicly_accessible = false
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  tags = {
    Name = "AUP PostgreSQL"
    Environment = "Development"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "aup-rds-sg"
  description = "Security group for AUP RDS instance"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this to your VPC
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "AUP RDS Security Group"
  }
}

# Create SSH key pair
resource "aws_key_pair" "aup_key" {
  key_name   = "aup-key"
  public_key = file("~/.ssh/id_rsa.pub")  # This assumes you have an existing SSH key pair
}
# EC2 Instance for connecting to RDS
resource "aws_instance" "aup_app_server" {
  ami                    = "ami-084568db4383264d4" 
  instance_type          = "t2.micro" 
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = aws_key_pair.aup_key.key_name  # Associate the key pair
  
  tags = {
    Name        = "AUP App Server"
    Environment = "Development"
  }
  
  user_data = <<-EOF
              #!/bin/bash
              echo "export DB_HOST=${aws_db_instance.aup_postgres.address}" >> /etc/environment
              echo "export DB_PORT=${aws_db_instance.aup_postgres.port}" >> /etc/environment
              echo "export DB_NAME=${aws_db_instance.aup_postgres.db_name}" >> /etc/environment
              echo "export DB_USER=${aws_db_instance.aup_postgres.username}" >> /etc/environment
              echo "export DB_PASSWORD=${random_password.db_password.result}" >> /etc/environment
              EOF
}

# Security group for the EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "aup-app-sg"
  description = "Security group for AUP application server"
  
  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this to your IP
  }
  
  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "AUP App Security Group"
  }
}

# Allow the EC2 instance to connect to the RDS instance
resource "aws_security_group_rule" "allow_ec2_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.rds_sg.id
  description              = "Allow EC2 instance to connect to RDS"
}
