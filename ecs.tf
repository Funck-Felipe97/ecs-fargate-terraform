resource "aws_ecs_cluster" "cluster-01" {
  name = "cluster-01"
}

resource "aws_ecs_service" "service-01" {
  name               = "service-01"
  cluster            = aws_ecs_cluster.cluster-01.id
  desired_count      = 2
  task_definition    = aws_ecs_task_definition.aws-project-task-01.arn
  launch_type        = "FARGATE"  
  platform_version   = "1.4.0"
  load_balancer {
    target_group_arn = aws_lb_target_group.ALBTG01.arn
    container_name   = "aws-project-01"
    container_port   = 8080
  }
  network_configuration {
    subnets = [aws_subnet.subnet-01.id, aws_subnet.subnet-02.id]
    security_groups = [aws_security_group.ecs-task-01.id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [desired_count] 
  }
  depends_on = [aws_lb_target_group.ALBTG01]
}

resource "aws_ecs_task_definition" "aws-project-task-01" {
  family                = "service-01"
  container_definitions = jsonencode([
    {
      name      = "aws-project-01"
      image     = "1743953/aws-fargate-course:0.0.6"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment: [
        {
          name  = "DB_DATABASE"
          value = "aws_fargate_db"
        },
        {
          name  = "DB_USERNAME"
          value = "felipe"
        },
        {
          name  = "DB_PASSWORD"
          value = "felipe123"
        },
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.endpoint
        },
        {
          name  = "spring.profiles.active"
          value = "test"
        }
      ]
    }
  ])
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory       = "1024"
  cpu          = "512"
}