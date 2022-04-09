resource "aws_lb" "ALB01" {
  name               = "ALB01"
  subnets            = [aws_subnet.subnet-01.id, aws_subnet.subnet-02.id]
  security_groups    = [aws_security_group.load-balancer-01.id]
  tags = {
    Environment = "service-01"
  }
}

resource "aws_lb_target_group" "ALBTG01" {
  name         = "ALBTG01"
  port         = 8080
  protocol     = "HTTP"
  target_type  = "ip"
  vpc_id       = aws_vpc.aws-fargate-vpc.id
  health_check {
      enabled = true
      matcher = "200"
      path    = "/actuator/health"
      port    = "8080"
  }
  depends_on = [aws_lb.ALB01]
}

resource "aws_lb_listener" "ALBL01" {
  load_balancer_arn = aws_lb.ALB01.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ALBTG01.arn
    type             = "forward"
  }
  depends_on = [aws_lb.ALB01]
}