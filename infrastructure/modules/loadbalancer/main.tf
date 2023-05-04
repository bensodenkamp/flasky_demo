resource "aws_security_group" "lb_sg" {
  name		= "allow-tcp-port-80-443"
  description   = "Allow tls traffic"
  vpc_id	= var.vpc_id

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "lb_sg_http" {
  name		    = "allow-tcp-port-80"
  description = "Allow clear traffic"
  vpc_id	    = var.vpc_id

  ingress {
    description      = "CLEAR"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_80"
  }
}

resource "aws_alb" "flasky_lb" {
  name			                  = "flasky-lb"
  internal		                = false

  enable_deletion_protection  = false
  subnets                     = [var.public_subnet_1_id,var.public_subnet_2_id]
  security_groups	            = [aws_security_group.lb_sg.id,aws_security_group.lb_sg_http.id] 
}


resource "aws_alb_listener" "alb_frontend_http" {
  load_balancer_arn	=	aws_alb.flasky_lb.arn
  port			=	"80"
	protocol	=	"HTTP"

  default_action {
    type    = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "flasky_demo" {
  name        = "ecs-target-group"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_listener" "alb_front_https" {
	load_balancer_arn	=	aws_alb.flasky_lb.arn
  certificate_arn   = var.cert_arn
	port			        =	"443"
	protocol		      =	"HTTPS"
	ssl_policy		    =	"ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.flasky_demo.id
    type             = "forward"
  }

}


output "listener_arn" {
  value = aws_alb_listener.alb_front_https.arn
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "lb_sg_http_id" {
  value = aws_security_group.lb_sg_http.id
}

output "lb_dns_name" {
  value = aws_alb.flasky_lb.dns_name
}

output "lb_zone_id" {
  value = aws_alb.flasky_lb.zone_id
}

output "lb_target_group_id" {
  value = aws_lb_target_group.flasky_demo.id
}