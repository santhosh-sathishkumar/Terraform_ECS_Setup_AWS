# Create a Loadbalancer for ECS

resource "aws_lb" "ecs-alb" {
    name = var.albname
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg-loadbalancer.id]
    subnets = aws_subnet.public.*.id 
    enable_deletion_protection = false

}

resource "aws_alb_target_group" "lb_tg_ecs" {
    name = "tg-ecs"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main-ecs.id
    target_type = "ip"

}

resource "aws_alb_listener" "listener_ecs" {
    load_balancer_arn = aws_lb.ecs-alb.id
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.lb_tg_ecs.id
    }
  
}