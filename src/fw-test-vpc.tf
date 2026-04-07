################################################################################
# VPC FW TEST
################################################################################

resource "aws_vpc" "fw_test_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.254.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "fw-test-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "fw_test_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "fw-test-igw"
  }
}


################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "server_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-fw-test-subnet-a"
  }
}

resource "aws_subnet" "server_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 11)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "server-fw-test-subnet-b"
  }
}

resource "aws_subnet" "server_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 12)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "server-fw-test-subnet-c"
  }
}

resource "aws_subnet" "tgw_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "tgw-fw-test-subnet-a"
  }
}

resource "aws_subnet" "tgw_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "tgw-fw-test-subnet-b"
  }
}

resource "aws_subnet" "tgw_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "tgw-fw-test-subnet-c"
  }
}

#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "server_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "server-fw-test-rt"
  }
}

resource "aws_route" "server_fw_test_route_to_igw" {
  provider = aws.primary
  
  route_table_id = aws_route_table.server_fw_test_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.fw_test_igw.id
}

resource "aws_route" "server_fw_test_route_to_cw" {
  provider = aws.primary
  
  route_table_id = aws_route_table.server_fw_test_rt.id
  destination_cidr_block = "10.0.0.0/8"
  core_network_arn = aws_networkmanager_core_network.core_network.arn
  }

resource "aws_route_table" "tgw_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "tgw-fw-test-rt"
  }
}

####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "server_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_a.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}

resource "aws_route_table_association" "server_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_b.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}

resource "aws_route_table_association" "server_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_c.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}


resource "aws_route_table_association" "tgw_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_a.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}

resource "aws_route_table_association" "tgw_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_b.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}

resource "aws_route_table_association" "tgw_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_c.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}
