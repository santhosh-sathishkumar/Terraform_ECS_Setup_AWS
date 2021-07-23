# Security Group for Load Balancer
resource "aws_security_group" "sg-loadbalancer" {
  name = "lb-security-group"
  description = "Allow inbound traffic to load balancer"
  vpc_id = aws_vpc.main-ecs.id

  ingress {
      description = "Allpw port 80, HTTP"
      from_port = "80"
      to_port = "80"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
      description = "Allow port 443, HTTPS"
      from_port = "443"
      to_port = "443"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
      protocol = "-1"
      from_port = "0"
      to_port = "0"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for ECS
resource "aws_security_group" "sg-ecs-task" {
    name = "ecs-task-sg"
    description = "Traffic to ecs tasks"
    vpc_id = aws_vpc.main-ecs.id

    ingress {
        description = "Allow inbound traffic from only loadbalancer sg"
        protocol = "tcp"
        from_port = var.app_port
        to_port = var.app_port
        security_groups = [aws_security_group.sg-loadbalancer.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
  }
  
}