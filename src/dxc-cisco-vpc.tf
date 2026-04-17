################################################################################
# VPC WAN
################################################################################

resource "aws_vpc" "dxc_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.240.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "dxc-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "dxc_vpc_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.dxc_vpc.id

  tags = {
    Name = "dxc-vpc-igw"
  }
}


################################################################################
# Subnets 
################################################################################
resource "aws_subnet" "cw_dxc_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "cw-dxc-subnet-a"
  }
}

resource "aws_subnet" "cw_dxc_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "cw-dxc-subnet-b"
  }
}

resource "aws_subnet" "cw_dxc_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "cw-dxc-subnet-c"
  }
}

resource "aws_subnet" "wan_dxc_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 8)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "wan-dxc-subnet-a"
  }
}

resource "aws_subnet" "wan_dxc_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 9)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "wan-dxc-subnet-b"
  }
}

resource "aws_subnet" "wan_dxc_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "wan-dxc-subnet-c"
  }
}

resource "aws_subnet" "public_dxc_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 12)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "public-dxc-subnet-a"
  }
}

resource "aws_subnet" "public_dxc_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 13)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "public-dxc-subnet-b"
  }
}

resource "aws_subnet" "public_dxc_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.dxc_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dxc_vpc.cidr_block, 8, 14)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "public-dxc-subnet-c"
  }
}

#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "wan_dxc_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.dxc_vpc.id

  tags = {
    Name = "server-dxc-rt"
  }
}

resource "aws_route_table" "public_dxc_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.dxc_vpc.id

  tags = {
    Name = "public-dxc-rt"
  }
}

resource "aws_route_table" "cw_dxc_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.dxc_vpc.id

  tags = {
    Name = "cw-dxc-rt"
  }
}



####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "wan_dxc_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.wan_dxc_subnet_a.id
  route_table_id = aws_route_table.wan_dxc_rt.id
}

resource "aws_route_table_association" "wan_dxc_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.wan_dxc_subnet_b.id
  route_table_id = aws_route_table.wan_dxc_rt.id
}

resource "aws_route_table_association" "wan_dxc_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.wan_dxc_subnet_c.id
  route_table_id = aws_route_table.wan_dxc_rt.id
}

resource "aws_route_table_association" "cw_dxc_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_dxc_subnet_a.id
  route_table_id = aws_route_table.cw_dxc_rt.id
}

resource "aws_route_table_association" "cw_dxc_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_dxc_subnet_b.id
  route_table_id = aws_route_table.cw_dxc_rt.id
}

resource "aws_route_table_association" "cw_dxc_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_dxc_subnet_c.id
  route_table_id = aws_route_table.cw_dxc_rt.id
}

resource "aws_route_table_association" "public_dxc_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_dxc_subnet_a.id
  route_table_id = aws_route_table.public_dxc_rt.id
}

resource "aws_route_table_association" "public_dxc_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_dxc_subnet_b.id
  route_table_id = aws_route_table.public_dxc_rt.id
}

resource "aws_route_table_association" "public_dxc_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_dxc_subnet_c.id
  route_table_id = aws_route_table.public_dxc_rt.id
}

#############################################################################
# Routing table content
#############################################################################

resource "aws_route" "public_igw_dxc_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.public_dxc_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.dxc_vpc_igw.id
}

# resource "aws_route" "cw_dxc_route" {
#   provider = aws.primary
  
#   route_table_id = aws_route_table.cw_dxc_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   # network_interface_id = aws_instance.cisco_dxc_instance_1.primary_network_interface_id
#   core_network_arn = aws_networkmanager_core_network.core_network.arn
# }

# resource "aws_route" "wan_dxc_route" {
#   provider = aws.primary
#   depends_on = [ aws_networkmanager_core_network_policy_attachment.cloudwan_better_policy_attachment]

#   route_table_id = aws_route_table.wan_dxc_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   core_network_arn = aws_networkmanager_core_network.core_network.arn
 
# }


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "cisco_dxc_1_g1_sg" {
  provider = aws.primary
  
  name        = "cisco-dxc-1-g1-sg"
  description = "Allow anything"
  vpc_id      = aws_vpc.dxc_vpc.id

# Allow all inbound traffic for testing purposes
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
    Name = "cisco-dxc-1-g1-sg"
  }
}

resource "aws_security_group" "cisco_dxc_1_g2_sg" {
  provider = aws.primary
  
  name        = "cisco-dxc-1-g2-sg"
  description = "Allow anything"
  vpc_id      = aws_vpc.dxc_vpc.id

# Allow all inbound traffic for testing purposes
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
    Name = "cisco-dxc-1-g2-sg"
  }
}

 resource "aws_instance" "cisco_dxc_instance_1" {
   provider = aws.primary
   
   ami = "ami-011a3f02bf1fbe77a"
   # instance_type = "t3.medium"
   instance_type = "c6in.xlarge"
   key_name = var.key_name
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   
   subnet_id = aws_subnet.wan_dxc_subnet_a.id
   private_ip = cidrhost(aws_subnet.wan_dxc_subnet_a.cidr_block, 10)
   security_groups = [aws_security_group.cisco_dxc_1_g1_sg.id]
   source_dest_check = false

user_data = <<-EOF
Section: IOS configuration 
hostname cisco-dxc-1
aaa new-model
username cisco privilege 15 secret cisco
aaa authentication login default local
aaa authorization exec default local
ip domain name csast.cz
crypto key generate rsa general-keys modulus 4096
ip ssh version 2
ip ssh server algorithm authentication password keyboard
line con 0
login authentication default
line vty 0 4
transport input ssh
login authentication default
interface GigabitEthernet1
ip address dhcp
no shut
ip route 0.0.0.0 0.0.0.0 ${cidrhost(aws_subnet.wan_dxc_subnet_a.cidr_block, 1)}
end
EOF

 tags = {
       Name = "cisco-dxc-instance-1"
   }

  lifecycle {
    ignore_changes = [network_interface, security_groups]
  }  
 }

resource "aws_network_interface" "cisco_dxc_1_g2_int" {
  provider = aws.primary
  subnet_id = aws_subnet.public_dxc_subnet_a.id
  private_ips = [cidrhost(aws_subnet.public_dxc_subnet_a.cidr_block, 10)]
  security_groups = [aws_security_group.cisco_dxc_1_g2_sg.id]
  source_dest_check = false
}

# attach second interface to instance
resource "aws_network_interface_attachment" "cisco_dxc_1_g2_attach" {
  provider = aws.primary
  instance_id = aws_instance.cisco_dxc_instance_1.id
  network_interface_id = aws_network_interface.cisco_dxc_1_g2_int.id
  device_index = 1
}

resource "aws_network_interface_attachment" "cisco_dxc_1_g3_attach" {
  provider = aws.primary
  instance_id = aws_instance.cisco_dxc_instance_1.id
  network_interface_id = aws_network_interface.cisco_dxc_1_g3_int.id
  device_index = 2
}

resource "aws_network_interface_attachment" "cisco_dxc_1_g4_attach" {
  provider = aws.primary
  instance_id = aws_instance.cisco_dxc_instance_1.id
  network_interface_id = aws_network_interface.cisco_dxc_1_g4_int.id
  device_index = 3
}
