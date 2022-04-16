resource "aws_db_subnet_group" "mysql-subnet-group" {
  name       = "mysql-subnet-group"
  subnet_ids = [
      aws_subnet.subnet-01.id,
      aws_subnet.subnet-02.id
  ]
}

resource "aws_db_instance" "mysql" {
  identifier           = "mysql-aws-fargate"  
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "aws_fargate_db"
  username             = "felipe"
  password             = "felipe123"
  parameter_group_name = "default.mysql5.7"
  port                 = 3306
  db_subnet_group_name = aws_db_subnet_group.mysql-subnet-group.name
  vpc_security_group_ids = [
      aws_security_group.rds-sg-01.id,
      aws_security_group.ecs-task-01.id
  ]
  skip_final_snapshot  = true
}