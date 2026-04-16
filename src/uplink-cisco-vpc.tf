################################################################################
# VPC FW TEST
################################################################################

resource "aws_vpc" "uplink_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.252.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "uplink-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "uplink_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.uplink_vpc.id

  tags = {
    Name = "uplink-igw"
  }
}


################################################################################
# Subnets 
################################################################################
resource "aws_subnet" "tgw_uplink_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "tgw-uplink-subnet-a"
  }
}

resource "aws_subnet" "tgw_uplink_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "tgw-uplink-subnet-b"
  }
}

resource "aws_subnet" "tgw_uplink_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "tgw-uplink-subnet-c"
  }
}

# resource "aws_subnet" "dxc_uplink_subnet_a" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 4)
#   availability_zone = "${var.aws_region1}a"

#   tags = {
#     Name = "dxc-uplink-subnet-a"
#   }
# }

# resource "aws_subnet" "dxc_uplink_subnet_b" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 5)
#   availability_zone = "${var.aws_region1}b"


#   tags = {
#     Name = "dxc-uplink-subnet-b"
#   }
# }

# resource "aws_subnet" "dxc_uplink_subnet_c" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 6)
#   availability_zone = "${var.aws_region1}c"


#   tags = {
#     Name = "dxc-uplink-subnet-c"
#   }
# }


resource "aws_subnet" "server_uplink_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 8)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-uplink-subnet-a"
  }
}

resource "aws_subnet" "server_uplink_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 9)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "server-uplink-subnet-b"
  }
}

resource "aws_subnet" "server_uplink_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "server-uplink-subnet-c"
  }
}

resource "aws_subnet" "public_uplink_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 12)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "public-uplink-subnet-a"
  }
}

resource "aws_subnet" "public_uplink_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 13)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "public-uplink-subnet-b"
  }
}

resource "aws_subnet" "public_uplink_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.uplink_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 14)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "public-uplink-subnet-c"
  }
}

# resource "aws_subnet" "vrf_test_uplink_subnet_a" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 16)
#   availability_zone = "${var.aws_region1}a"

#   tags = {
#     Name = "vrf-test-uplink-subnet-a"
#   }
# }

# resource "aws_subnet" "vrf_test_uplink_subnet_b" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 17)
#   availability_zone = "${var.aws_region1}b"


#   tags = {
#     Name = "vrf-test-uplink-subnet-b"
#   }
# }

# resource "aws_subnet" "vrf_test_uplink_subnet_c" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 18)
#   availability_zone = "${var.aws_region1}c"


#   tags = {
#     Name = "vrf-test-uplink-subnet-c"
#   }
# }

# resource "aws_subnet" "vrf_prod_uplink_subnet_a" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 20)
#   availability_zone = "${var.aws_region1}a"

#   tags = {
#     Name = "vrf-prod-uplink-subnet-a"
#   }
# }

# resource "aws_subnet" "vrf_prod_uplink_subnet_b" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 21)
#   availability_zone = "${var.aws_region1}b"


#   tags = {
#     Name = "vrf-prod-uplink-subnet-b"
#   }
# }

# resource "aws_subnet" "vrf_prod_uplink_subnet_c" {
#   provider = aws.primary
  
#   vpc_id            = aws_vpc.uplink_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.uplink_vpc.cidr_block, 8, 22)
#   availability_zone = "${var.aws_region1}c"


#   tags = {
#     Name = "vrf-prod-uplink-subnet-c"
#   }
# }


#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "server_uplink_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.uplink_vpc.id

  tags = {
    Name = "server-uplink-rt"
  }
}

# resource "aws_route_table" "dxc_uplink_rt" {
#   provider = aws.primary

#   vpc_id = aws_vpc.uplink_vpc.id

#   tags = {
#     Name = "dxc-uplink-rt"
#   }
# }

resource "aws_route_table" "public_uplink_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.uplink_vpc.id

  tags = {
    Name = "public-uplink-rt"
  }
}

resource "aws_route_table" "tgw_uplink_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.uplink_vpc.id

  tags = {
    Name = "tgw-uplink-rt"
  }
}


# resource "aws_route_table" "vrf_test_uplink_rt" {
#   provider = aws.primary

#   vpc_id = aws_vpc.uplink_vpc.id

#   tags = {
#     Name = "vrf-test-uplink-rt"
#   }
# }

# resource "aws_route_table" "vrf_prod_uplink_rt" {
#   provider = aws.primary

#   vpc_id = aws_vpc.uplink_vpc.id

#   tags = {
#     Name = "vrf-prod-uplink-rt"
#   }
# }



####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "server_uplink_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_uplink_subnet_a.id
  route_table_id = aws_route_table.server_uplink_rt.id
}

resource "aws_route_table_association" "server_uplink_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_uplink_subnet_b.id
  route_table_id = aws_route_table.server_uplink_rt.id
}

resource "aws_route_table_association" "server_uplink_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_uplink_subnet_c.id
  route_table_id = aws_route_table.server_uplink_rt.id
}

resource "aws_route_table_association" "tgw_uplink_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_uplink_subnet_a.id
  route_table_id = aws_route_table.tgw_uplink_rt.id
}

resource "aws_route_table_association" "tgw_uplink_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_uplink_subnet_b.id
  route_table_id = aws_route_table.tgw_uplink_rt.id
}

resource "aws_route_table_association" "tgw_uplink_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_uplink_subnet_c.id
  route_table_id = aws_route_table.tgw_uplink_rt.id
}

resource "aws_route_table_association" "dxc_uplink_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.dxc_uplink_subnet_a.id
  route_table_id = aws_route_table.dxc_uplink_rt.id
}

resource "aws_route_table_association" "dxc_uplink_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.dxc_uplink_subnet_b.id
  route_table_id = aws_route_table.dxc_uplink_rt.id
}

resource "aws_route_table_association" "dxc_uplink_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.dxc_uplink_subnet_c.id
  route_table_id = aws_route_table.dxc_uplink_rt.id
}

resource "aws_route_table_association" "public_uplink_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_uplink_subnet_a.id
  route_table_id = aws_route_table.public_uplink_rt.id
}

resource "aws_route_table_association" "public_uplink_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_uplink_subnet_b.id
  route_table_id = aws_route_table.public_uplink_rt.id
}

resource "aws_route_table_association" "public_uplink_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_uplink_subnet_c.id
  route_table_id = aws_route_table.public_uplink_rt.id
}

# resource "aws_route_table_association" "vrf_test_uplink_rt_assoc_a" {
#   provider = aws.primary

#   subnet_id      = aws_subnet.vrf_test_uplink_subnet_a.id
#   route_table_id = aws_route_table.vrf_test_uplink_rt.id
# }

# resource "aws_route_table_association" "vrf_test_uplink_rt_assoc_b" {
#   provider = aws.primary

#   subnet_id      = aws_subnet.vrf_test_uplink_subnet_b.id
#   route_table_id = aws_route_table.vrf_test_uplink_rt.id
# }

# resource "aws_route_table_association" "vrf_test_uplink_rt_assoc_c" {
#   provider = aws.primary

#   subnet_id      = aws_subnet.vrf_test_uplink_subnet_c.id
#   route_table_id = aws_route_table.vrf_test_uplink_rt.id
# }

#############################################################################
# Routing table content
#############################################################################

resource "aws_route" "public_igw_uplink_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.public_uplink_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.uplink_igw.id
}

resource "aws_route" "cisco_g1_uplink_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.tgw_uplink_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #vpc_endpoint_id = "value"
  network_interface_id = aws_instance.cisco_uplink_instance_1.primary_network_interface_id
}

# resource "aws_route" "server_uplink_route" {
#   provider = aws.primary
#   depends_on = [ aws_networkmanager_core_network_policy_attachment.cloudwan_better_policy_attachment]

#   route_table_id = aws_route_table.server_uplink_rt.id
#   destination_cidr_block = "10.0.0.0/8"
#   core_network_arn = aws_networkmanager_core_network.core_network.arn
 
# }


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "server_uplink_sg" {
  provider = aws.primary
  
  name        = "allow-any"
  description = "Allow anything"
  vpc_id      = aws_vpc.uplink_vpc.id

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
}

resource "aws_network_interface" "cisco_uplink_1_g1" {
  provider = aws.primary
  subnet_id = aws_subnet.server_uplink_subnet_a.id
  private_ips = [cidrhost(aws_subnet.server_uplink_subnet_a.cidr_block, 10)]
  security_groups = [aws_security_group.server_uplink_sg.id]
  source_dest_check = false
}
  
resource "aws_network_interface" "cisco_uplink_1_g2" {
  provider = aws.primary
  subnet_id = aws_subnet.public_uplink_subnet_a.id
  private_ips = [cidrhost(aws_subnet.public_uplink_subnet_a.cidr_block, 10)]
  security_groups = [aws_security_group.server_uplink_sg.id]
  source_dest_check = false
}


 resource "aws_instance" "cisco_uplink_instance_1" {
   provider = aws.primary
   
   ami = "ami-011a3f02bf1fbe77a"
   instance_type = "t3.medium"
   key_name = var.key_name
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   
user_data = <<-EOF
Section: IOS configuration 
hostname cisco-uplink-1
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
ip route 0.0.0.0 0.0.0.0 ${cidrhost(aws_subnet.server_uplink_subnet_a.cidr_block, 1)}
end
EOF


  # network_interface {
  #   device_index = 0
  #   network_interface_id = aws_network_interface.vrf_test_cisco_uplink_1.id
  # }

  # network_interface {
  #   device_index = 1
  #   network_interface_id = aws_network_interface.vrf_prod_cisco_uplink_1.id
  # }  

  tags = {
       Name = "cisco-uplink-instance-1"
   }
 }

