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
    default = "80"
}

variable "cluster_name" {
    description = "Name for the cluster"
    default = "counter-app"
}

variable "albname" {
    description = "Provide name for load balancer"
    default = "albecs" 
}

variable "fargate_cpu" {
    description = "Amount of CPU required for the task"
    default     = "1024"
}

variable "fargate_memory" {
    description = "Amount of memor required for task"
    default     = "2048"
}

variable "tag" {
    description = "Enter the image tag to run"
}