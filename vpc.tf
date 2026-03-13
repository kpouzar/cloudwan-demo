################################################################################
# VPC
################################################################################

resource "aws_vpc" "region1_vpc" {
  provider = aws.primary
  count = var.vpc_amount

  cidr_block           = cidrsubnet(var.vpc_cidr1, 6, count.index)
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "test-vpc-${count.index}"
    Environment = element(var.vpc_environment, count.index)
  }
}

################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "server_a_region1_subnet" {
  count = var.vpc_amount
  provider = aws.primary
  
  vpc_id            = aws_vpc.region1_vpc[count.index].id
  cidr_block        = cidrsubnet(aws_vpc.region1_vpc[count.index].cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-a-vpc${count.index}-subnet"
  }
}

resource "aws_subnet" "tgw_a_region1_subnet" {
  count = var.vpc_amount
  provider = aws.primary
  
  vpc_id            = aws_vpc.region1_vpc[count.index].id
  cidr_block        = cidrsubnet(aws_vpc.region1_vpc[count.index].cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "tgw-a-vpc${count.index}-subnet"
  }
}



#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "private_region1_rt" {
  count = var.vpc_amount
  provider = aws.primary

  vpc_id = aws_vpc.region1_vpc[count.index].id

  tags = {
    Name = "private-vpc${count.index}-rt"
  }
}

resource "aws_route_table" "tgw_region1_rt" {
  count = var.vpc_amount
  provider = aws.primary

  vpc_id = aws_vpc.region1_vpc[count.index].id

  tags = {
    Name = "tgw-vpc${count.index}-rt"
  }
}

####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "vpc_pub_a_region1_rt_assoc" {
  count = var.vpc_amount
  provider = aws.primary

  subnet_id      = aws_subnet.server_a_region1_subnet[count.index].id
  route_table_id = aws_route_table.private_region1_rt[count.index].id
}

resource "aws_route_table_association" "vpc_tgw_a_region1_rt_assoc" {
  count = var.vpc_amount
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_a_region1_subnet[count.index].id
  route_table_id = aws_route_table.tgw_region1_rt[count.index].id
}

####################################################################################################################################
# REGION 2
####################################################################################################################################

################################################################################
# VPC
################################################################################

resource "aws_vpc" "region2_vpc" {
  provider = aws.secondary
  count = var.vpc_amount

  cidr_block           = cidrsubnet(var.vpc_cidr2, 6, count.index)
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "test-vpc-${count.index}"
    Environment = element(var.vpc_environment, count.index)
  }
}

################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "server_a_region2_subnet" {
  count = var.vpc_amount
  provider = aws.secondary
  
  vpc_id            = aws_vpc.region2_vpc[count.index].id
  cidr_block        = cidrsubnet(aws_vpc.region2_vpc[count.index].cidr_block, 8, 10)
  availability_zone = "${var.aws_region2}a"

  tags = {
    Name = "server-a-vpc${count.index}-subnet"
  }
}

resource "aws_subnet" "tgw_a_region2_subnet" {
  count = var.vpc_amount
  provider = aws.secondary
  
  vpc_id            = aws_vpc.region2_vpc[count.index].id
  cidr_block        = cidrsubnet(aws_vpc.region2_vpc[count.index].cidr_block, 8, 0)
  availability_zone = "${var.aws_region2}a"

  tags = {
    Name = "tgw-a-vpc${count.index}-subnet"
  }
}



#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "private_region2_rt" {
  count = var.vpc_amount
  provider = aws.secondary

  vpc_id = aws_vpc.region2_vpc[count.index].id

  tags = {
    Name = "private-vpc${count.index}-rt"
  }
}

resource "aws_route_table" "tgw_region2_rt" {
  count = var.vpc_amount
  provider = aws.secondary

  vpc_id = aws_vpc.region2_vpc[count.index].id

  tags = {
    Name = "tgw-vpc${count.index}-rt"
  }
}

####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "vpc_pub_a_region2_rt_assoc" {
  count = var.vpc_amount
  provider = aws.secondary

  subnet_id      = aws_subnet.server_a_region2_subnet[count.index].id
  route_table_id = aws_route_table.private_region2_rt[count.index].id
}

resource "aws_route_table_association" "vpc_tgw_a_region2_rt_assoc" {
  count = var.vpc_amount
  provider = aws.secondary

  subnet_id      = aws_subnet.tgw_a_region2_subnet[count.index].id
  route_table_id = aws_route_table.tgw_region2_rt[count.index].id
}