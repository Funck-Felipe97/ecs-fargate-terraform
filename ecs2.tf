resource "aws_ecs_service" "service-02" {
  name               = "service-02"
  cluster            = aws_ecs_cluster.cluster-01.id
  desired_count      = 2
  task_definition    = aws_ecs_task_definition.aws-project-task-02.arn
  launch_type        = "FARGATE"  
  platform_version   = "1.4.0"
  load_balancer {
    target_group_arn = aws_lb_target_group.ALBTG02.arn 
    container_name   = "aws-project-02"
    container_port   = 8080
  }
  network_configuration {
    subnets = [aws_subnet.subnet-01.id, aws_subnet.subnet-02.id]
    security_groups = [aws_security_group.ecs-task-02.id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [desired_count] 
  }
  depends_on = [aws_lb_target_group.ALBTG02]            
}

resource "aws_ecs_task_definition" "aws-project-task-02" {
  family                = "service-02"
  container_definitions = jsonencode([
    {
      name      = "aws-project-02"
      image     = "1743953/aws-fargate-course-events:1.0.0"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory       = "1024"
  cpu          = "512"
}