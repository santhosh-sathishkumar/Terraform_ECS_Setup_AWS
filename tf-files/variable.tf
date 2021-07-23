variable "region" {
    description = "AWS region for resource creation"
    default = "us-east-1" 
}

variable "az_count" {
    description = "Required Availability Zone Count"
    default = "2"
}

variable "app_port" {
    description = "Port where application exopsed by container"
    default = "3000"
}

variable "app_name" {
    description = "Application Name"
}

variable "albname" {
    description = "Provide name for load balancer"
    default = "albecs" 
}

variable "app_image" {
    description = "images url"
}

variable "fargate_cpu" {
    description = "Amount of CPU required for the task"
}

variable "fargate_memory" {
    description = "Amount of memor required for task"
}

variable "tag" {
    description = "Tag for the project"
}