# Create ECS cluster for tasks to run

resource "aws_ecs_cluster" "main-ecs" {
    name = "${var.cluster-name}-cluster"
  
}

/* resource "aws_ecs_task_definition" "app" {
    family = "news-app"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    cpu                      = 256
    memory                   = 512
    container_definitions = jsonencode([
        {
            "name": "helloworld",
            "image": "heroku/nodejs-hello-world",
            "networkMode": "awsvpc",
            "portMappings": [
                {
                    "containerPort": 3000,
                    "hostPort": 3000
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "helloworld-app",
                    "awslogs-region": "us-east-1"
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ])
  
} */

data "aws_ecr_repository" "react-repo" {
    name = "react-js"
}
data "template_file" "helloworld" {
    template = file("./templates/taskdefinition.json.tpl")

    vars = {
        app_image      = data.aws_ecr_repository.react-repo.repository_url
        app_port       = var.app_port
        fargate_cpu    = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws_region     = var.region
        tag            = var.tag
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "helloworldapp"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.helloworld.rendered
}

resource "aws_ecs_service" "helloworld" {
    name = "helloworld"
    cluster = aws_ecs_cluster.main-ecs.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count = 2
    launch_type = "FARGATE"

    network_configuration {
      security_groups = [ aws_security_group.sg-loadbalancer.id, aws_security_group.sg-ecs-task.id ]
      subnets = aws_subnet.private.*.id
      assign_public_ip = false
    }

    load_balancer {
      target_group_arn = aws_alb_target_group.lb_tg_ecs.id
      container_name = "helloworld"
      container_port = var.app_port
    }
    
    depends_on = [aws_alb_listener.listener_ecs]
}
