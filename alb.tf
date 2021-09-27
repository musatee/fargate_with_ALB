# ALB for front-end container
resource "aws_alb" "front_end" {
  name            = "IM-alb-frontend"
  subnets         = [aws_subnet.public.id, aws_subnet.public_subnet_db_2.id]
  security_groups = [aws_security_group.alb_frontend.id]
}

# ALB for web container
resource "aws_alb" "web" {
  name            = "IM-alb-web"
  subnets         = [aws_subnet.public.id, aws_subnet.public_subnet_db_2.id]
  security_groups = [aws_security_group.alb_web.id]
} 



## frontend_tg target group 
resource "aws_alb_target_group" "frontend_tg" {
  name        = "IM-frontend-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "50"
    port                = 3001
    protocol            = "HTTP" 
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
} 

## web_tg target group 
resource "aws_alb_target_group" "web_tg" {
  name        = "IM-web-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "50"
    port                = 3000
    protocol            = "HTTP" 
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# listener for front-end container ALB
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.front_end.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.frontend_tg.id
    type             = "forward"
  }
} 

# listener for web container ALB
resource "aws_alb_listener" "web" {
  load_balancer_arn = aws_alb.web.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.web_tg.id
    type             = "forward"
  }
} 
