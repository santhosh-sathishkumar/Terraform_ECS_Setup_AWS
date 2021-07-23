data "aws_availability_zones" "available" {
  state = "available"

}

# Create a VPC resource

resource "aws_vpc" "main-ecs" {
  cidr_block = "10.20.0.0/16"

}

# Create a Public and Private subnets

resource "aws_subnet" "private" {
    count = var.az_count
    cidr_block = cidrsubnet(aws_vpc.main-ecs.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.main-ecs.id

}

resource "aws_subnet" "public" {
    count = "2"
    cidr_block = cidrsubnet(aws_vpc.main-ecs.cidr_block, 8, count.index + var.az_count)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.main-ecs.id
    map_public_ip_on_launch = true
}

# Create a internet Gawteway to connnect Outside World

resource "aws_internet_gateway" "gw-ecs" {
    vpc_id = aws_vpc.main-ecs.id
  
}

resource "aws_route" "internet-access" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_vpc.main-ecs.main_route_table_id
    gateway_id = aws_internet_gateway.gw-ecs.id  

}

resource "aws_eip" "ng-ip" {
    count = var.az_count
    vpc = true
    depends_on = [aws_internet_gateway.gw-ecs]
  
}

resource "aws_nat_gateway" "ng" {
    count = var.az_count
    subnet_id = element(aws_subnet.public.*.id, count.index)
    allocation_id =  element(aws_eip.ng-ip.*.id, count.index)
  
}

resource "aws_route_table" "private-rt" {
    count = var.az_count
    vpc_id = aws_vpc.main-ecs.id

    route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = element(aws_nat_gateway.ng.*.id, count.index)
    }
  
}

resource "aws_route_table_association" "private-route" {
    count = "2"
    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private-rt.*.id, count.index)
  
}