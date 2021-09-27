# security.tf

# SG for Postgres 
resource "aws_security_group" "postgres" {
  name        = "IM_postgres-SG"
  description = "allow inbound  5432 access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    cidr_blocks = [aws_vpc.main.cidr_block, "223.25.252.198/32"] 
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

# Traffic to front-end container ALB should follow this SG
resource "aws_security_group" "alb_frontend" {
  name        = "IM_alb-frontend-SG"
  description = "allow inbound 80 access"
  vpc_id      = aws_vpc.main.id

#  ingress {
#    protocol        = "tcp"
#    from_port       = 3001
#    to_port         = 3001
#    cidr_blocks = ["0.0.0.0/0"] 
#  } 
#
#  ingress {
#    protocol        = "tcp"
#    from_port       = 3000
#    to_port         = 3000
#    cidr_blocks = ["0.0.0.0/0"] 
#  } 

   ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"] 
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

# Traffic to web container ALB should follow this SG
resource "aws_security_group" "alb_web" {
  name        = "IM_alb-web-SG"
  description = "allow inbound 80 access"
  vpc_id      = aws_vpc.main.id

#  ingress {
#    protocol        = "tcp"
#    from_port       = 3001
#    to_port         = 3001
#    cidr_blocks = ["0.0.0.0/0"] 
#  } 
#
#  ingress {
#    protocol        = "tcp"
#    from_port       = 3000
#    to_port         = 3000
#    cidr_blocks = ["0.0.0.0/0"] 
#  } 

   ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"] 
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 


# Traffic to ECS service should follow this SG
resource "aws_security_group" "ecs" {
  name        = "IM_ecs-SG"
  description = "allow traffic only from the front-end & web load balancer"
  vpc_id      = aws_vpc.main.id

#   ingress {
#    protocol        = "tcp"
#    from_port       = 80
#    to_port         = 80
#    #security_groups = [aws_security_group.alb.id] 
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#   ingress {
#    protocol        = "tcp"
#    from_port       = 3000
#    to_port         = 3000
#    #security_groups = [aws_security_group.alb.id] 
#    cidr_blocks = ["0.0.0.0/0"]
#  } 
#
#    ingress {
#    protocol        = "tcp"
#    from_port       = 3001
#    to_port         = 3001
#    #security_groups = [aws_security_group.alb.id] 
#    cidr_blocks = ["0.0.0.0/0"]
#  } 

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [aws_security_group.alb_frontend.id, aws_security_group.alb_web.id]  
    #cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 
