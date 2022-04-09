resource "aws_security_group" "load-balancer-01" {
  vpc_id = aws_vpc.aws-fargate-vpc.id
}

resource "aws_security_group" "ecs-task-01" {
  vpc_id = aws_vpc.aws-fargate-vpc.id
}

resource "aws_security_group_rule" "ingress-load-balancer-http-01" {
  from_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.load-balancer-01.id
  to_port = 8080
  cidr_blocks = [
    "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress-load-balancer-https-01" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.load-balancer-01.id
  to_port = 443
  cidr_blocks = [
    "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress-ecs-task-elb-01" {
  from_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.ecs-task-01.id
  to_port = 8080
  source_security_group_id = aws_security_group.load-balancer-01.id
  type = "ingress"
}

resource "aws_security_group_rule" "egress-load-balancer-01" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load-balancer-01.id
}

resource "aws_security_group_rule" "egress-ecs-task-01" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs-task-01.id
}