################################################################################
# VPC RTR
################################################################################

resource "aws_vpc" "rtr_prod_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.242.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "rtr-prod-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
# resource "aws_internet_gateway" "rtr_prod_vpc_igw" {
#   provider = aws.primary
#   vpc_id = aws_vpc.rtr_prod_vpc.id

#   tags = {
#     Name = "rtr-prod-vpc-igw"
#   }
# }


################################################################################
# Subnets 
################################################################################
resource "aws_subnet" "cw_rtr_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "cw-rtr-prod-subnet-a"
  }
}

resource "aws_subnet" "cw_rtr_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "cw-rtr-prod-subnet-b"
  }
}

resource "aws_subnet" "cw_rtr_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "cw-rtr-prod-subnet-c"
  }
}

resource "aws_subnet" "server_rtr_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 8)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-rtr-prod-subnet-a"
  }
}

resource "aws_subnet" "server_rtr_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 9)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "server-rtr-prod-subnet-b"
  }
}

resource "aws_subnet" "server_rtr_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.rtr_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.rtr_prod_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "server-rtr-prod-subnet-c"
  }
}

#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "server_rtr_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.rtr_prod_vpc.id

  tags = {
    Name = "server-rtr-prod-rt"
  }
}

resource "aws_route_table" "public_rtr_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.rtr_prod_vpc.id

  tags = {
    Name = "public-rtr-prod-rt"
  }
}

resource "aws_route_table" "cw_rtr_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.rtr_prod_vpc.id

  tags = {
    Name = "cw-rtr-prod-rt"
  }
}



####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "server_rtr_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_rtr_prod_subnet_a.id
  route_table_id = aws_route_table.server_rtr_prod_rt.id
}

resource "aws_route_table_association" "server_rtr_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_rtr_prod_subnet_b.id
  route_table_id = aws_route_table.server_rtr_prod_rt.id
}

resource "aws_route_table_association" "server_rtr_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_rtr_prod_subnet_c.id
  route_table_id = aws_route_table.server_rtr_prod_rt.id
}

resource "aws_route_table_association" "cw_rtr_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_rtr_prod_subnet_a.id
  route_table_id = aws_route_table.cw_rtr_prod_rt.id
}

resource "aws_route_table_association" "cw_rtr_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_rtr_prod_subnet_b.id
  route_table_id = aws_route_table.cw_rtr_prod_rt.id
}

resource "aws_route_table_association" "cw_rtr_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_rtr_prod_subnet_c.id
  route_table_id = aws_route_table.cw_rtr_prod_rt.id
}

#############################################################################
# Routing table content
#############################################################################

resource "aws_route" "cw_rtr_prod_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.cw_rtr_prod_rt.id
  destination_cidr_block = "0.0.0.0/0"
  # network_interface_id = aws_instance.cisco_dxc_instance_1.primary_network_interface_id
  core_network_arn = aws_networkmanager_core_network.core_network.arn
}

resource "aws_route" "server_rtr_prod_route" {
  provider = aws.primary
  depends_on = [ aws_networkmanager_core_network_policy_attachment.cloudwan_better_policy_attachment]

  route_table_id = aws_route_table.server_rtr_prod_rt.id
  destination_cidr_block = "0.0.0.0/0"
  core_network_arn = aws_networkmanager_core_network.core_network.arn
 
}


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "cisco_dxc_1_g4_sg" {
  provider = aws.primary
  
  name        = "cisco-dxc-1-g4-sg"
  description = "Allow anything"
  vpc_id      = aws_vpc.rtr_prod_vpc.id

# Allow all inbound traffic for proding purposes
  ingress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cisco-dxc-1-g4-sg"
  }
}

resource "aws_network_interface" "cisco_dxc_1_g4_int" {
  provider = aws.primary
  subnet_id = aws_subnet.cw_rtr_prod_subnet_a.id
  private_ips = [cidrhost(aws_subnet.cw_rtr_prod_subnet_a.cidr_block, 10)]
  security_groups = [aws_security_group.cisco_dxc_1_g4_sg.id]
  source_dest_check = false
  
}
  
