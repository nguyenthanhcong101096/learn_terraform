resource "aws_ecs_task_definition" "task_definition" {
  family = var.ecs_task_definiton_name

  container_definitions =  file("${path.module}/task_definition.json")

  volume {
    name = "db_data"
    host_path = "/home/ec2-user/db_data"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "service" {
    # iam_role        = aws_iam_role.ecs_service_role.name
  name                = var.ecs_service_name
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 2
}
