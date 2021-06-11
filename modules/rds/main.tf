resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "mysql-group-${var.app}-${var.env}"
  description = "rds database subnet group"
  subnet_ids  = var.private_subnets
}

resource "aws_db_instance" "mysql" {
    identifier                = "mysql-${var.app}-${var.env}"
    allocated_storage         = 5
    backup_retention_period   = 2
    backup_window             = "01:00-01:30"
    maintenance_window        = "sun:03:00-sun:03:30"
    multi_az                  = true
    engine                    = var.db_engine
    engine_version            = var.db_version
    instance_class            = var.db_instance_class
    name                      = "worker_db"
    username                  = "congnt"
    password                  = "password"
    port                      = "3306"
    db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.id
    vpc_security_group_ids    = [var.rds_security_group]
    skip_final_snapshot       = true
    final_snapshot_identifier = "worker-final"
    publicly_accessible       = true
}
