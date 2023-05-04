resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "flasky-exec-role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "flasky_demo_def" {
  family                    = "flasky_demo"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 1024
  memory                    = 2048
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn

container_definitions = jsonencode([
    {
      name                  = "flasky_demo"
      image                 = "${var.repo_url}:latest"
      cpu                   = 1024
      memory                = 2048
      networkMode           = "awsvpc"
      portMappings          = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "flasky-cluster" {
  name = "flasky-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name		      = "allow-tcp-port-5000-from-lb"
  description   = "Allow web traffic from lb"
  vpc_id        = var.vpc_id
  
  ingress {
    description      = "WEB"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    security_groups  = [var.lb_sg_id] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_ecs_service" "flasky-service" {
  name            = "flasky_demo-service"
  cluster         = aws_ecs_cluster.flasky-cluster.id
  task_definition = aws_ecs_task_definition.flasky_demo_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    subnets         = [var.subnet_1_id, var.subnet_2_id]
  }

  load_balancer {
    target_group_arn = var.target_group_id
    container_name   = "flasky_demo"
    container_port   = 5000
  }
}