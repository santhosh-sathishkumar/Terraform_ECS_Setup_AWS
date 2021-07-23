output "load_balancer_ip" {
  value = aws_lb.ecs-alb.dns_name
}