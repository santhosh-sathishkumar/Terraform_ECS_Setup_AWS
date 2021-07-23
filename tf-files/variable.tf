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
    default = "news-api-app"
}

variable "albname" {
    description = "Provide name for load balancer"
    default = "elbecs"
  
}