resource "aws_vpc" "ADU-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ADU-VPC"
  }
}

#creating subnets
#public
resource "aws_subnet" "sub-1-public" {
  vpc_id     = aws_vpc.ADU-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub-1-public"
  }
}

#private subnet
resource "aws_subnet" "sub-2-private" {
  vpc_id     = aws_vpc.ADU-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "sub-1-private"
  }
}

# creating public route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.ADU-VPC.id
  tags = {
    Name = "public-route-table"
  }
}

# private
# creating  route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.ADU-VPC.id
  tags = {
    Name = "private-route-table"
  }
}

#public route association
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.sub-1-public.id
  route_table_id = aws_route_table.public-route-table.id
}

#private route table association
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.sub-2-private.id
  route_table_id = aws_route_table.private-route-table.id
}

# igw
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.ADU-VPC.id

  tags = {
    Name = "IGW"
  }
}


resource "aws_route" "public-IGW-route" {
  route_table_id            = aws_route_table.public-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.IGW.id
}
